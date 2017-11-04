class AddAddressToFamily < ActiveRecord::Migration[5.1]
  def change
    add_column :families, :address, :string
  end
end
