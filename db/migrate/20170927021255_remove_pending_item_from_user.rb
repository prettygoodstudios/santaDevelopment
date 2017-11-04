class RemovePendingItemFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :pendingItem, :collection
  end
end
