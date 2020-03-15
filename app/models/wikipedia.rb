class Wikipedia < ApplicationRecord
  # belongs_to :service
  has_many :sources
end
