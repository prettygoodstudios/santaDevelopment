class AddBlankToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :pendingItems, :array
  end
end
