class AddLeftToFamily < ActiveRecord::Migration[5.1]
  def change
    add_column :families, :left, :integer
  end
end
