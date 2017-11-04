class AddCollumnToFamily < ActiveRecord::Migration[5.1]
  def change
    add_column :families, :item_id, :integer
  end
end
