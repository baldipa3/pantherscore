require 'rails'
require 'faker'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'pry-rails'

puts 'Clearing everything.'

Review.destroy_all
User.destroy_all
UserService.destroy_all
ServiceCategory.destroy_all
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
ServiceTosdr.destroy_all
ServiceHibp.destroy_all
ServiceWikipedia.destroy_all
Service.destroy_all

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
      pantherscore: rand(1..10)
    )

    # Service Categories

    categories = service['categories'].map { |category| Category.find_by(name: category) }
    categories.each do |category|
      new_service.categories << category unless category.nil?
    end
  end
end

# Alternatives

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

# Infosec seed

puts "Seeding PrivacyMonitor data..."

privacymonitor = JSON.parse(File.read('./db/data/infosec/privacymonitor.json'))
privacymonitor.each do |slug, result|
  Privacymonitor.create!(
    slug: slug,
    score: result['score'],
    title: result['title'],
    trend: result['trend']
    )
end

puts "Seeding PrivacyScore data..."

privacyscore = JSON.parse(File.read('./db/data/infosec/privacyscore_new.json'))
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

puts "Seeding Pribot data..."

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

puts "Seeding tosdr data..."

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

puts "Seeding HIBP data..."

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

puts "Seeding Wikipedia data..."

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
      link: source['link'],
      )
  end
end

# Infosec associations

puts "Creating infosec associations..."

Service.all.each do |service|

  # PrivacyMonitor
  privacymonitor = Privacymonitor.find_by(slug: service.slug)
  service.privacymonitor = privacymonitor unless privacymonitor.nil?

  # PrivacyScore
  privacyscores = Privacyscore.where(slug: service.slug)
  unless privacyscores.nil?
    privacyscores.each do |privacyscore|
      service.privacyscores << privacyscore
    end
  end

  # Pribot
  pribots = Pribot.where(slug: service.slug)
  unless pribots.nil?
    pribots.each do |pribot|
      service.pribots << pribot
    end
  end

  # Not very DRY, I know...

  # clean_slug = service.name.gsub(/\++$/, '\+\+')
  # name_query = "/\s#{clean_slug}|#{clean_slug}\s|\s#{clean_slug}\s|\A#{clean_slug}\z/"
  # slug_query = "/\s#{service.slug}|#{service.slug}\s|\s#{service.slug}\s|\A#{service.slug}\z/"
  # company_name_query = "/\s#{service.company_name}|#{service.company_name}\s|\s#{service.company_name}\s|\A#{service.company_name}\z/"

  # Tosdr
  service.tosdrs << Tosdr.where('name ILIKE :search', search: service.name)
  # if service.tosdrs.empty?
  #   service.tosdrs << Tosdr.where('name ~* :search', search: name_query)
  # end
  if service.tosdrs.empty?
    service.tosdrs << Tosdr.where('name ILIKE :search', search: service.slug)
  end
  # if service.tosdrs.empty?
  #   service.tosdrs << Tosdr.where('name ~* :search', search: slug_query)
  # end
  if service.tosdrs.empty? && service.company_name.present?
    service.tosdrs << Tosdr.where('name ILIKE :search', search: service.company_name)
  end
  # if service.tosdrs.empty? && service.company_name.present?
  #   service.tosdrs << Tosdr.where('name ~* :search', search: company_name_query)
  # end

  # Hibp
  breach = Hibp.find_by('name ILIKE :search', search: service.name)
  service.hibp = breach unless breach.nil?
  # if service.hibp.nil?
  #   breach = Hibp.find_by('name ~* :search', search: name_query)
  #   service.hibp = breach unless breach.nil?
  # end
  if service.hibp.nil?
    breach = Hibp.find_by('name ILIKE :search', search: service.slug)
    service.hibp = breach unless breach.nil?
  end
  # if service.hibp.nil?
  #   breach = Hibp.find_by('name ~* :search', search: slug_query)
  #   service.hibp = breach unless breach.nil?
  # end
  if service.hibp.nil? && service.company_name.present?
    breach = Hibp.find_by('name ILIKE :search', search: service.company_name)
    service.hibp = breach unless breach.nil?
  end
  # if service.hibp.nil? && service.company_name.present?
  #   breach = Hibp.find_by('name ~* :search', search: company_name_query)
  #   service.hibp = breach unless breach.nil?
  # end

  # Wikipedia
  service.wikipedias << Wikipedia.where('name ILIKE :search', search: service.name)
  # if service.wikipedias.empty?
  #   service.wikipedias << Wikipedia.where('name ~* :search', search: name_query)
  # end
  if service.wikipedias.empty?
    service.wikipedias << Wikipedia.where('name ILIKE :search', search: service.slug)
  end
  # if service.wikipedias.empty?
  #   service.wikipedias << Wikipedia.where('name ~* :search', search: slug_query)
  # end
  if service.wikipedias.empty? && service.company_name.present?
    service.wikipedias << Wikipedia.where('name ILIKE :search', search: service.company_name)
  end
  # if service.wikipedias.empty? && service.company_name.present?
  #   service.wikipedias << Wikipedia.where('name ~* :search', search: company_name_query)
  # end
end

# Users

puts "Creating random Users and Reviews"

200.times do
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
