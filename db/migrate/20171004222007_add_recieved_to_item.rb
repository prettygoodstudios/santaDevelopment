class AddRecievedToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :recieved, :boolean
  end
end
