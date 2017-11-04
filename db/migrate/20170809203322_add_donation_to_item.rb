class AddDonationToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :donation, :boolean
  end
end
