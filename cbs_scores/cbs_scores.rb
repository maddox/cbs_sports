class CbsScores
  attr_accessor :games

  MENS_BASKETBALL_URL = "http://www.sportsline.com/collegebasketball/scoreboard"
  
  def initialize(sport)
    self.games = []

    case sport
    when :mens_basketball
      mens_basketball_doc = Hpricot(open(MENS_BASKETBALL_URL, 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)' ))
      mens_basketball_doc.search("//span[@id*='board']").each do |game_html|
        games << parse_basketball_game(game_html)
      end
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
      game.time_left = Time.at($1.to_i).strftime('%I:%M %p %Z')
    when /Postponed/
      game.started = false
      game.completed = false
      game.time_left = 'Postponed'
    end

    game.team1[:name] = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td b").inner_html
    game.team1[:rank] = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td font").inner_html
    game.team2[:name] = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td b").inner_html
    game.team2[:rank] = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td font").inner_html

    if game.started?
      game.team1[:score] = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td:last b").inner_html
      game.team2[:score] = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td:last b").inner_html
    end

    game

  end


  
end

