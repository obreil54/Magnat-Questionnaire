class ChangeStatusInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :status, :boolean, null: false
  end
end
