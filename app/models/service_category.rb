class ServiceCategory < ApplicationRecord
  belongs_to :service
  belongs_to :category

  validates :category_id, uniqueness: { scope: :service_id }
end
