puts "🌱 Seeding spices..."

# generate 20 unique boards
Board.generate_board until Board.all.count == 20

#generate fake users
5.times do
    name = Faker::Name.name
    username = Faker::Beer.brand.gsub(/\s+/, "")
    password = Faker::Types.rb_string
    Player.create(name: name, username: username, password: password)
end

#simulate each user playing each board
# Player.all.each do |player|
#     Board.all.each do |board|
#         unused_nums = (0..99).to_a
#         unused_nums = unused_nums.join(' ')
#         new_game = PlayedBoard.create(player_id: player[:id], board_id: board[:id], unused_nums: unused_nums)
#         #new_game.sim_play until new_game.is_full?
#         puts new_game
#     end
# end

puts "✅ Done seeding!"
