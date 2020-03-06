class CreateAlternatives < ActiveRecord::Migration[5.2]
  def change
    create_table :alternatives do |t|
      t.integer :service_id
      t.integer :alternative_id

      t.timestamps
    end
  end
end
