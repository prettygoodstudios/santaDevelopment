class AddCollumnToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :family_id, :integer
  end
end
