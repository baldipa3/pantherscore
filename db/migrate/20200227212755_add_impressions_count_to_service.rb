class AddImpressionsCountToService < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :impressions_count, :int
  end
end
