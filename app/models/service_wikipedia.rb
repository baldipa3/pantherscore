class ServiceWikipedia < ApplicationRecord
  belongs_to :service
  belongs_to :wikipedia

  validates :wikipedia_id, uniqueness: { scope: :service_id }
end
