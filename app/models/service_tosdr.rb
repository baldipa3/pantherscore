class ServiceTosdr < ApplicationRecord
  belongs_to :service
  belongs_to :tosdr

  validates :tosdr_id, uniqueness: { scope: :service_id }
end
