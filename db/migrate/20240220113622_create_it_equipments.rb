class CreateItEquipments < ActiveRecord::Migration[7.1]
  def change
    create_table :it_equipments do |t|
      t.string :category
      t.string :make
      t.string :model
      t.text :description
      t.datetime :loaned_at
      t.boolean :status
      t.string :user_id
      t.string :integer

      t.timestamps
    end
    add_index :it_equipments, :user_id
  end
end
