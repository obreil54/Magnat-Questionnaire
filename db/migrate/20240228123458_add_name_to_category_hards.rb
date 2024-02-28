class AddNameToCategoryHards < ActiveRecord::Migration[7.1]
  def change
    add_column :category_hards, :name, :string
  end
end
