class Service < ApplicationRecord
  has_many :reviews
  has_many :users, through: :user_services
  has_many :categories, presence: true
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true
  validates :description, presence: true, uniqueness: true
  # has_one_attached :photo
end
