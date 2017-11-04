class AddTotalCostToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :totalCost, :decimal
  end
end
