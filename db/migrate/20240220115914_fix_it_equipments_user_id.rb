class FixItEquipmentsUserId < ActiveRecord::Migration[7.1]
  def change
    change_column :it_equipments, :user_id, 'bigint USING CAST(user_id AS bigint)'

    remove_column :it_equipments, :integer, :string

    add_foreign_key :it_equipments, :users
  end
end
