class RemoveItemsAvailableFromItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :itemsAvailable, :integer
  end
end
