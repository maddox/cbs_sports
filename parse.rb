require 'cbs_scores'



scores = CbsScores.new



scores.find_completed_games.each do |game|
  puts game.inspect
end

puts
puts

scores.find_current_games.each do |game|
  puts game.inspect
end

puts
puts

scores.find_next_games.each do |game|
  puts game.inspect
end

