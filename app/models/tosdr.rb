class Tosdr < ApplicationRecord
  has_many :service_tosdrs
  has_many :services, through: :service_tosdrs
end
