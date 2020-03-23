class Wikipedia < ApplicationRecord
  has_many :service_wikipedias
  has_many :services, through: :service_wikipedias

  has_many :sources, class_name: 'WikipediaSource'
end
