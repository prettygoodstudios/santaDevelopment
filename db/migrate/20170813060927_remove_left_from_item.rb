class RemoveLeftFromItem < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :left, :integer
  end
end
