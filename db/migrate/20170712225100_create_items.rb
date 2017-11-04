class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.numeric :quantity
      t.numeric :age
      t.string :member
      t.timestamps
    end
  end
end
