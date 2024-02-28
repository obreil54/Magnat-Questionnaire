class RemoveFieldsFromHardware < ActiveRecord::Migration[7.1]
  def change
    remove_column :hardwares, :category, :string
    remove_column :hardwares, :make, :string
    remove_column :hardwares, :description, :text
  end
end
