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

# sql_query = " \
#         name ILIKE :query \
#         OR name ~* :query \
#         OR slug ILIKE :query \
#         OR slug ~* :query \
#         OR company_name ILIKE :query \
#         OR company_name ~* :query \
#       "
# Tosdr.all.each do |tosdr|
#   service = Service.find_by(sql_query, query: "#{tosdr.name}")
#   service.tosdrs << tosdr
# end
