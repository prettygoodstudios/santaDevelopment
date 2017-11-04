class AddCityToFamily < ActiveRecord::Migration[5.1]
  def change
    add_column :families, :city, :string
  end
end
