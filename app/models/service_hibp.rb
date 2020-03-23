class ServiceHibp < ApplicationRecord
  belongs_to :service
  belongs_to :hibp

  validates :hibp_id, uniqueness: { scope: :service_id }
end
