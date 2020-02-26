class AddUsernameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
    add_column :users, :my_pantherscore, :integer
  end
end
