class CreateTosdrs < ActiveRecord::Migration[5.2]
  def change
    create_table :tosdrs do |t|
      t.string :name
      t.string :polarity
      t.string :score
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
