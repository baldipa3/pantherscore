class CreateWikipedia < ActiveRecord::Migration[5.2]
  def change
    create_table :wikipedia do |t|
      t.string :name
      t.string :date
      t.string :records
      t.string :sector
      t.string :method

      t.timestamps
    end
  end
end
