class AddZipToFamily < ActiveRecord::Migration[5.1]
  def change
    add_column :families, :zip, :integer
  end
end
