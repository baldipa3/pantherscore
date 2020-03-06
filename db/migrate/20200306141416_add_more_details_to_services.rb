class AddMoreDetailsToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :slug, :string
    add_column :services, :lead, :string
    add_column :services, :company_name, :string
    add_column :services, :company_url, :string
  end
end
