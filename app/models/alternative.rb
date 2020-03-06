class Alternative < ApplicationRecord
  belongs_to :service, class_name: 'Service'
  belongs_to :alternative, class_name: 'Service'

  validates :alternative_id, uniqueness: { scope: :service_id }
end
