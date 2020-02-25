class Review < ApplicationRecord
  belongs_to :user
  belongs_to :service

  validates :rating, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10, only_integer: true }
  validates :content, presence: true, length: { minimum: 280 }
end
