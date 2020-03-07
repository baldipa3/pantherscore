require 'faker'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'pry'

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

# Services

services = JSON.parse(File.read('./db/services_custom.json'))
services['services'].each do |service|

  new_service = Service.create!(
    name: service['name'],
    slug: service['slug'],
    lead: service['lead'],
    company_name: service['company_name'],
    company_url: service['company_url'],
    description: service['description'],
    url: service['url'],
    icon: service['icon_url'],
    pantherscore: rand(1..100)
  )

  # Service Categories

  categories = service['categories'].map { |category| Category.find_by(name: category) }
  categories.each do |category|
    new_service.categories << category unless category.nil?
  end
end

  # Service Alternatives

services['services'].each do |service|
  existing_service = Service.find_by(slug: service['slug'])
  # binding.pry
  alternative_services = service['alternatives'].map { |alternative| Service.find_by(slug: alternative['slug']) }
  alternative_services.each do |alternative|
    existing_service.alternatives << alternative unless alternative.nil?
  end
end

# Users

20.times do
  user = User.create!(
    username: Faker::Internet.username,
    email: Faker::Internet.free_email,
    password: '123456',
  )

  # User Reviews

  rand(1..10).times do
    review = Review.create!(
      rating: rand(1..10),
      content: Faker::Lorem.paragraph_by_chars(number: 280),
      upvote: rand(1..5),
      downvote: rand(1..5),
      service_id: rand(1..50),
      user_id: user.id,
    )
  end

  # User Services

  user.services << [
    Service.find_by_id(rand(1..10)),
    Service.find_by_id(rand(11..20)),
    Service.find_by_id(rand(21..30)),
    Service.find_by_id(rand(31..40)),
    Service.find_by_id(rand(41..50)),
  ]
end

puts 'Complete!'
