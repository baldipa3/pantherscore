class Review < ApplicationRecord
  belongs_to :user

  validates :rating, presence: true
  validates :content, presence: true, length: { minimum: 280 }
end
