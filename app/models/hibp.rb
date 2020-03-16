class Hibp < ApplicationRecord
  has_many :service_hibps
  has_many :services, through: :service_hibp
end
