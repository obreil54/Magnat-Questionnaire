class RenameItEquipmentsToHardware < ActiveRecord::Migration[7.1]
  def change
    rename_table :it_equipments, :hardwares
  end
end
