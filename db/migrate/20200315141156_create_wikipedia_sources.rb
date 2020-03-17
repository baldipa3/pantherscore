class CreateWikipediaSources < ActiveRecord::Migration[5.2]
  def change
    create_table :wikipedia_sources do |t|
      t.references :wikipedia, foreign_key: true
      t.string :name
      t.string :link

      t.timestamps
    end
  end
end
