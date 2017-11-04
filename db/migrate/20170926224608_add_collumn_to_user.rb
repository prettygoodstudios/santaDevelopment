class AddCollumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :contacted, :boolean
  end
end
