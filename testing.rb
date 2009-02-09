require 'cbs_scores'



cbs_scores = CbsScores.new(:nascar_cup)

puts cbs_scores.race.drivers.inspect


# scores.completed_games.each do |game|
#   puts game.inspect
# end
# 
# puts
# puts
# 
# scores.current_games.each do |game|
#   puts game.inspect
# end
# 
# puts
# puts
# 
# scores.upcoming_games.each do |game|
#   puts game.inspect
# end
# 
