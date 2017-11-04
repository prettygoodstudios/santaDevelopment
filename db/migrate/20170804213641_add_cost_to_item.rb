class AddCostToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :cost, :decimal
  end
end
