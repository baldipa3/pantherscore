class CreatePrivacyscores < ActiveRecord::Migration[5.2]
  def change
    create_table :privacyscores do |t|
      t.references :service, foreign_key: true
      t.string :slug
      t.string :classification
      t.string :polarity
      t.string :title
      t.string :description

      t.timestamps
    end
  end
end
