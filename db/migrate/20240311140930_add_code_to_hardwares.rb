class AddCodeToHardwares < ActiveRecord::Migration[7.1]
  def change
    add_column :hardwares, :code, :string
  end
end
