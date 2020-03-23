class CreateServiceHibps < ActiveRecord::Migration[5.2]
  def change
    create_table :service_hibps do |t|
      t.references :service, foreign_key: true
      t.references :hibp, foreign_key: true

      t.timestamps
    end
  end
end
