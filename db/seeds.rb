require 'rails'
require 'faker'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'pry-rails'

puts 'Clearing everything.'

# Joins
UserService.destroy_all
ServiceCategory.destroy_all
ServiceTosdr.destroy_all
ServiceHibp.destroy_all
ServiceWikipedia.destroy_all

# Normal
Review.destroy_all
Category.destroy_all
UserService.destroy_all
Review.destroy_all
User.destroy_all
Service.destroy_all
Privacymonitor.destroy_all
Privacyscore.destroy_all
Pribot.destroy_all
Tosdr.destroy_all
Hibp.destroy_all
Wikipedia.destroy_all
WikipediaSource.destroy_all


# Categories from AlternativeTo

puts "Creating Categories..."

categories = Nokogiri::HTML(open('https://alternativeto.net/').read)

categories.search('.sub-categories-menu li').each do |category|
  Category.create!( name: category.text.strip )
end

# Services

puts "Creating Services..."

services = JSON.parse(File.read('./db/data/services/services_10p.json'))
services['services'].each do |service|

  unless service['discontinued'] == true
    new_service = Service.create!(
      name: service['name'],
      slug: service['slug'],
      lead: service['lead'],
      company_name: service['company_name'],
      company_url: service['company_url'],
      description: service['description'],
      url: service['url'],
      icon: service['icon_url'],
    )

    # Service Categories

    categories = service['categories'].map { |category| Category.find_by(name: category) }
    categories.each do |category|
      new_service.categories << category unless category.nil?
    end
  end
end

# # Alternatives

puts "Creating Alternatives..."

services['services'].each do |service|
  current_service = Service.find_by(slug: service['slug'])
  unless current_service.nil? # Because it would be a discontinued service
    # puts current_service.name
    alternative_services = service['alternatives'].map { |alternative| Service.find_by(slug: alternative['slug']) }
    alternative_services.each do |alternative|
      # puts "Alternative: #{alternative.name unless alternative.nil?}"
      current_service.alternatives << alternative unless alternative.nil?
    end
  end
end

# Pantherscore

puts "Adding pre-compiled Pantherscores to Services"

services = JSON.parse(File.read('./db/data/infosec/pantherscores.json'))

services.each do |service|
  current_service = Service.find_by(slug: service['slug'])
  if current_service.present?
    current_service.pantherscore = service['pantherscore']
    current_service.save!
  end
end

# Users

puts "Creating random Users and Reviews"

50.times do
  user = User.create!(
    username: Faker::Internet.username,
    email: Faker::Internet.free_email,
    password: '123456',
  )

  # User Reviews

  total = Service.all.count

  rand(1..200).times do
    review = Review.create!(
      rating: rand(1..10),
      content: Faker::Lorem.paragraph_by_chars(number: 280),
      upvote: rand(1..5),
      downvote: rand(1..5),
      service_id: rand(1..total),
      user_id: user.id,
    )
  end

  # User Services

  user.services << [
    Service.find_by_id(rand(1..(total/5))),
    Service.find_by_id(rand(((total/5)+1)..((total/5)*2))),
    Service.find_by_id(rand((((total/5)*2)+1)..((total/5)*3))),
    Service.find_by_id(rand((((total/5)*3)+1)..((total/5)*4))),
    Service.find_by_id(rand((((total/5)*4)+1)..total))
  ]
end

puts 'Complete!'
