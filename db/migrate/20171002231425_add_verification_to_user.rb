class AddVerificationToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email_verify, :boolean
    add_column :users, :token, :string
  end
end
