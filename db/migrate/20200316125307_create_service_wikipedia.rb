class CreateServiceWikipedia < ActiveRecord::Migration[5.2]
  def change
    create_table :service_wikipedia do |t|
      t.references :service, foreign_key: true
      t.references :wikipedia, foreign_key: true

      t.timestamps
    end
  end
end
