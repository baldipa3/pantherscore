class CreatePrivacymonitors < ActiveRecord::Migration[5.2]
  def change
    create_table :privacymonitors do |t|
      t.references :service, foreign_key: true
      t.string :slug
      t.integer :score
      t.string :title
      t.string :trend

      t.timestamps
    end
  end
end
