class ChangeStatusInHardwares < ActiveRecord::Migration[7.1]
  def change
    change_column :hardwares, :status, :boolean, null: false, default: false
  end
end
