class UserService < ApplicationRecord
  belongs_to :users
  belongs_to :services
end
