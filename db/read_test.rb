require 'rails'
require 'faker'
require 'open-uri'
require 'nokogiri'
require 'json'

pm_factors = JSON.parse(File.read('./db/data/infosec/privacymonitor.json'))

pm_factors.each do |service, factors|
  puts service
  puts factors['score']
end
