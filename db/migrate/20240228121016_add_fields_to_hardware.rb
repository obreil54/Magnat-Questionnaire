class AddFieldsToHardware < ActiveRecord::Migration[7.1]
  def change
    add_column :hardwares, :series, :string
    add_reference :hardwares, :category_hard, foreign_key: true
  end
end
