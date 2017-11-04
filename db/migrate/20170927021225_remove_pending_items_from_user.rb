class RemovePendingItemsFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :pendingItems, :array
  end
end
