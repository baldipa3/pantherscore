class Service < ApplicationRecord
  has_many :reviews
  has_many :users, through: :user_services
  has_many :categories
  validates :name, presence: true, uniqueness: true
  validates :url, presence: true
  validates :description, presence: true, uniqueness: true
  validates :categories, presence: true
  # has_one_attached :photo
end
