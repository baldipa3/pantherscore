class CreateServiceTosdrs < ActiveRecord::Migration[5.2]
  def change
    create_table :service_tosdrs do |t|
      t.references :service, foreign_key: true
      t.references :tosdr, foreign_key: true

      t.timestamps
    end
  end
end
