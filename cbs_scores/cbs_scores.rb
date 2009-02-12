class CbsScores
  attr_accessor :games, :race

  MENS_BASKETBALL_URL = "http://www.cbssports.com/collegebasketball/scoreboard"
  NASCAR_CUP_URL = "http://www.cbssports.com/autoracing/series/CUP"
  
  def initialize(sport)
    self.games = []

    case sport
    when :mens_basketball
      mens_basketball_doc = Hpricot(open(MENS_BASKETBALL_URL, 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)' ))
      mens_basketball_doc.search("//span[@id*='board']").each do |game_html|
        games << parse_basketball_game(game_html)
      end
    when :nascar_cup
      nascar_cup_doc = open(NASCAR_CUP_URL, 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)' ).read
      nascar_cup_doc.match(/eval\((\{.*\}\})\);/)
      nascar_cup_data = JSON.parse($1.gsub(/, \"raceStats.*\"/, ''))["AutoLeaderboard"]
      

      self.race = parse_nascar_race(nascar_cup_data)
    end

  end
  
  
  def method_missing(method, *args, &block)
    if method.to_s =~ /(\w+)_games/
      self.find_games_via_state($1)
    else
      super
    end
  end
    
  
  def find_games_via_state(state)
    found_games = []
    self.games.each do |game|
      found_games << game if game.send(state + '?')
    end
    found_games
  end
  



  private
  
  def parse_nascar_race(race_data)
    race = NascarRace.new
    
    race.lead_changes = race_data["raceStatus"]["leadChanges"]
    race.laps_completed = race_data["raceStatus"]["lapsCompleted"]
    race.race_status = race_data["raceStatus"]["raceStatus"]
    race.laps_under_caution = race_data["raceStatus"]["lapsUnderCaution"]
    race.race_track = race_data["raceStatus"]["raceTrack"]
    race.race_series = race_data["raceStatus"]["raceSeries"]
    race.leaders = race_data["raceStatus"]["leaders"]
    race.race_name = race_data["raceStatus"]["raceName"]
    
    race_data["raceDrivers"].each do |driver|
      r = RacecarDriver.new      
      r.status = driver["status"]
      r.car_number = driver["carNumber"]
      r.laps_completed = driver["lapsCompleted"]
      r.current_position = driver["currentPos"]
      r.points_earned = driver["ptsEarned"]
      r.car_make = driver["carMake"]
      r.starting_position = driver["startPos"]
      r.name = driver["driverName"]
      race.drivers << r
    end
    
    race
  end

  def parse_basketball_game(game_html)
    game = BasketballGame.new

    game.time_left = Hpricot(game_html.to_s).at("//span div table tr:nth(0) td b").inner_html

    case game.time_left
    when "Final"
      game.started = true
      game.completed = true
    when /left|Halftime/
      game.started = true
      game.completed = false
    when /(\d\d\d\d\d\d\d\d+)/
      game.started = false
      game.completed = false
      game.time_left = Time.at($1.to_i).strftime('%l:%M %p %Z')
    when /Postponed/
      game.started = false
      game.completed = false
      game.time_left = 'Postponed'
    end

    game.team1[:name] = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td b").inner_html
    game.team2[:name] = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td b").inner_html
    begin
      game.team1[:seed] = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td font").inner_html.gsub('#','')
      game.team1[:seed] = nil if game.team1[:seed] == "&laquo"
    rescue Exception => e
      game.team1[:seed] = nil
    end

    begin
      game.team2[:seed] = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td font").inner_html.gsub('#','')
      game.team2[:seed] = nil if game.team2[:seed] == "&laquo"
    rescue Exception => e
      game.team2[:seed] = nil
    end

    if game.started?
      game.team1[:score] = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td:last b").inner_html
      game.team2[:score] = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td:last b").inner_html
    end

    game

  end


  
end

