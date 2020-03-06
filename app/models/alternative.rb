class Alternative < ApplicationRecord
  belongs_to :service, class_name: 'Service'
  belongs_to :alternative, class_name: 'Service'

  validates :alternative_id, uniqueness: { scope: :service_id }

  validate :disallow_self_reference

  def disallow_self_reference
    errors.add(:service_id, 'cannot refer back to the same service') if service_id == alternative_id
  end
end
