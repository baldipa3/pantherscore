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
Service.destroy_all
Category.destroy_all

puts 'Creating services and categories'

# Categories from AlternativeTo

categories = Nokogiri::HTML(open('https://alternativeto.net/').read)

categories.search('.sub-categories-menu').each do |category|
  Category.create!( name: category.text.strip )
end

# Random services

100.times do
  Service.create! (
    name: Faker::App.name,
    url: Faker::Internet.domain_name,
    description: Faker::Lorem.paragraph_by_chars(number: 256),
    pantherscore: rand(1..100)
  )
end

puts 'Complete!'
