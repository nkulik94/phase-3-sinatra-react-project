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

puts "✅ Done seeding!"
