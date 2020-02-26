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

puts 'Clearing services and categories'
ServiceCategory.destroy_all
Service.destroy_all
Category.destroy_all

puts 'Creating services and categories'

# Categories from AlternativeTo

categories = Nokogiri::HTML(open('https://alternativeto.net/').read)

categories.search('.sub-categories-menu li').each do |category|
  Category.create!( name: category.text.strip )
end

# Random services

50.times do
  service = Service.create!(
    name: Faker::App.name,
    url: Faker::Internet.domain_name,
    description: Faker::Lorem.paragraph_by_chars(number: 256),
    pantherscore: rand(1..100)
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



puts 'Complete!'
