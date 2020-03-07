# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
require 'open-uri'
require 'nokogiri'

puts 'Clearing services, categories, users and reviews'
ServiceCategory.destroy_all
UserService.destroy_all
Service.destroy_all
Category.destroy_all
UserService.destroy_all
Review.destroy_all
User.destroy_all

puts 'Creating services, categories, users and reviews'

# Categories from AlternativeTo

categories = Nokogiri::HTML(open('https://alternativeto.net/').read)

categories.search('.sub-categories-menu li').each do |category|
  Category.create!( name: category.text.strip )
end

# Random services

25.times do
  name = Faker::App.name
  slug = name.downcase.gsub(" ", "-")
  service = Service.create!(
    name: name,
    url: Faker::Internet.domain_name,
    description: Faker::Lorem.paragraph_by_chars(number: 280),
    pantherscore: rand(1..100),
    slug: slug
  )
  total_categories = Category.all.count
  half_categories = total_categories / 2
  first_category = Category.find_by_id(rand(1..half_categories))
  service.categories << first_category
  rand(0..1).times do
    second_category = Category.find_by_id(rand((half_categories + 1)..total_categories))
    service.categories << second_category
  end
end

# Alternatives

id = 1

25.times do
  Service.find_by_id(id).alternatives << Service.find_by_id(((1..5).to_a - [id]).sample)
  Service.find_by_id(id).alternatives << Service.find_by_id(((6..10).to_a - [id]).sample)
  Service.find_by_id(id).alternatives << Service.find_by_id(((11..15).to_a - [id]).sample)
  Service.find_by_id(id).alternatives << Service.find_by_id(((16..20).to_a - [id]).sample)
  Service.find_by_id(id).alternatives << Service.find_by_id(((21..25).to_a - [id]).sample)
  id +=1
end

# Users

20.times do
  user = User.create!(
    username: Faker::Internet.username,
    email: Faker::Internet.free_email,
    password: '123456',
  )
  rand(1..10).times do
    review = Review.create!(
      rating: rand(1..10),
      content: Faker::Lorem.paragraph_by_chars(number: 280),
      upvote: rand(1..5),
      downvote: rand(1..5),
      service_id: rand(1..25),
      user_id: user.id,
    )
  end
  user.services << [
    Service.find_by_id(rand(1..5)),
    Service.find_by_id(rand(6..10)),
    Service.find_by_id(rand(11..15)),
    Service.find_by_id(rand(16..20)),
    Service.find_by_id(rand(21..25)),
  ]
end

puts 'Complete!'
