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
  else
    game.started = false
    game.completed = false
  end
  
  game.team1 = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td b").inner_html
  game.team2 = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td b").inner_html
  
  

  if game.started?
    puts game.inspect
    game.score1 = Hpricot(game_html.to_s).at("//span div table tr:nth(1) td:nth(3) b").innerHTML
    game.score2 = Hpricot(game_html.to_s).at("//span div table tr:nth(2) td:nth(3) b").inner_html
  end
  
  game

end

games = []
#doc = Hpricot(open("data.html"))
doc = Hpricot(open("http://www.sportsline.com/collegebasketball/scoreboard"))

doc.search("//span[@id*='board']").each do |game_html|
  games << parse_game(game_html)
end

puts games.class
