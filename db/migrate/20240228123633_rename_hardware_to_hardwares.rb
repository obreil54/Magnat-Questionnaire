class RenameHardwareToHardwares < ActiveRecord::Migration[7.1]
  def change
    rename_table :hardware, :hardwares
  end
end
