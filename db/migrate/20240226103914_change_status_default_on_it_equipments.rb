class ChangeStatusDefaultOnItEquipments < ActiveRecord::Migration[7.1]
  def change
    change_column_default :it_equipments, :status, from: nil, to: false
  end
end
