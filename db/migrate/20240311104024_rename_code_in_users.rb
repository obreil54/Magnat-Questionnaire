class RenameCodeInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :code, :log_in_code
  end
end
