require 'rubygems'
require 'hpricot'
require 'open-uri'


class Game
  attr_accessor :team1, :team2, :score1, :score2, :time_left, :completed, :started
  
  def complete?
    self.completed
  end

  def started?
    self.started
  end
  
end


def parse_game(game_html)
  game = Game.new
  
  game.time_left = Hpricot(game_html.to_s).at("//span div table tr:nth(0) td b").inner_html
  
  case game.time_left
  when "Final"
    game.started = true
    game.completed = true
  when /left/
    game.started = true
    game.completed = false
  when /(\d\d\d\d\d\d\d\d+)/
    game.started = false
    game.completed = false
    game.time_left = Time.at($1.to_i).strftime('%I:%M %p %Z')
  end
  
  
  game.team1 = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td b").inner_html
  game.team2 = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td b").inner_html
  
  if game.started?
    game.score1 = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td:last b").inner_html
    game.score2 = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td:last b").inner_html
  end
  
  game

end

games = []
doc = Hpricot(open("data.html"))
# doc = Hpricot(open("http://www.sportsline.com/collegebasketball/scoreboard", 'User-Agent' => 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)' ))


doc.search("//span[@id*='board']").each do |game_html|
  games << parse_game(game_html)
end

games.each do |game|
  puts game.inspect
end
