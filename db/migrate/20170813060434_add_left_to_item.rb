class AddLeftToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :left, :integer
  end
end
