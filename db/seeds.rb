require 'rails'
require 'faker'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'pry-rails'

puts 'Clearing services, categories, users and reviews'
ServiceCategory.destroy_all
UserService.destroy_all
Service.destroy_all
Category.destroy_all
UserService.destroy_all
Review.destroy_all
User.destroy_all
Privacymonitor.destroy_all
Privacyscore.destroy_all
Pribot.destroy_all
Tosdr.destroy_all
Hibp.destroy_all
Wikipedia.destroy_all
WikipediaSource.destroy_all


puts 'Creating services, categories, users and reviews'

# Categories from AlternativeTo

categories = Nokogiri::HTML(open('https://alternativeto.net/').read)

categories.search('.sub-categories-menu li').each do |category|
  Category.create!( name: category.text.strip )
end

# Services

services = JSON.parse(File.read('./db/data/services/services_custom.json'))
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

# Infosec

puts "Seeding PrivacyMonitor..."

privacymonitor = JSON.parse(File.read('./db/data/infosec/privacymonitor.json'))
privacymonitor.each do |slug, result|
  Privacymonitor.create!(
    slug: slug,
    score: result['score'],
    title: result['title'],
    trend: result['trend']
    )
end

puts "Seeding PrivacyScore..."

privacyscore = JSON.parse(File.read('./db/data/infosec/privacyscore.json'))
privacyscore.each do |slug, factors|
  factors.each do |factor|
    Privacyscore.create!(
      slug: slug,
      classification: factor['type'],
      polarity: factor['polarity'],
      title: factor['title'],
      description: factor['description']
      )
  end
end

puts "Seeding Pribot..."

pribot = JSON.parse(File.read('./db/data/infosec/pribot.json'))
pribot.each do |slug, factors|
  factors.each do |factor|
    Pribot.create!(
      slug: slug,
      polarity: factor['polarity'],
      title: factor['title']
      )
  end
end

puts "Seeding tosdr..."

tosdr = JSON.parse(File.read('./db/data/infosec/tosdr.json'))
tosdr['services'].each do |service|
  service['factors'].each do |factor|
    Tosdr.create!(
    name: service['name'],
    polarity: factor['polarity'],
    score: factor['score'],
    title: factor['title'],
    description: factor['description']
    )
  end
end

puts "Seeding HIBP..."

hibp = JSON.parse(File.read('./db/data/infosec/hibp.json'))
hibp['breaches'].each do |breach|
  Hibp.create!(
    name: breach['entity'],
    date: breach['date'],
    records: breach['records'],
    data: breach['data'],
    description: breach['description']
    )
end

puts "Seeding Wikipedia..."

wikipedia = JSON.parse(File.read('./db/data/infosec/wikipedia.json'))
wikipedia['breaches'].each do |breach|
  current_wikipedia = Wikipedia.create!(
    name: breach['entity'],
    date: breach['date'],
    records: breach['records'],
    sector: breach['sector'],
    method: breach['method']
    )
  breach['sources'].each do |source|
    wikipedia_source = WikipediaSource.create!(
      name: source['name'],
      url: source['url'],
      wikipedia_id: current_wikipedia
      )
  end
end

# Service Elements

services['services'].each do |service|
  current_service = Service.find_by(slug: service['slug'])

  # Alternatives
  alternative_services = service['alternatives'].map { |alternative| Service.find_by(slug: alternative['slug']) }
  alternative_services.each do |alternative|
    current_service.alternatives << alternative unless alternative.nil?
  end

  # PrivacyMonitor
  privacymonitor = Privacymonitor.find_by(slug: service['slug'])
  current_service.privacymonitor = privacymonitor unless privacymonitor.nil?

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
