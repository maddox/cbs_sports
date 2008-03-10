require 'cbs_scores'



scores = CbsScores.new(:mens_basketball)



scores.completed_games.each do |game|
  puts game.inspect
end

puts
puts

scores.current_games.each do |game|
  puts game.inspect
end

puts
puts

scores.next_games.each do |game|
  puts game.inspect
end

