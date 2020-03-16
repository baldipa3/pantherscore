class CreateHibps < ActiveRecord::Migration[5.2]
  def change
    create_table :hibps do |t|
      t.string :name
      t.string :date
      t.string :records
      t.string :data
      t.string :description

      t.timestamps
    end
  end
end
