class Category < ApplicationRecord
  belongs_to :service
  validates :name, presence: true
end
