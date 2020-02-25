class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :name
      t.string :url
      t.text :description
      t.integer :pantherscore
      t.float :user_score
      t.string :category

      t.timestamps
    end
  end
end
