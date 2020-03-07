class Service < ApplicationRecord
  is_impressionable :counter_cache => true, :column_name => :impressions_count

  has_many :alternative_services, foreign_key: :service_id, class_name: 'Alternative'
  has_many :alternatives, through: :alternative_services

  has_many :reviews

  has_many :user_services
  has_many :users, through: :user_services

  has_many :service_categories
  has_many :categories, through: :service_categories

  validates :name, presence: true # , uniqueness: true
  # validates :url, presence: true
  validates :description, presence: true, uniqueness: true
  # validates :categories, presence: true
  # has_one_attached :photo
end
