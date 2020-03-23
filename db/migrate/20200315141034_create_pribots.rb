class CreatePribots < ActiveRecord::Migration[5.2]
  def change
    create_table :pribots do |t|
      t.references :service, foreign_key: true
      t.string :slug
      t.string :polarity
      t.string :title

      t.timestamps
    end
  end
end
