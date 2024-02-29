class RemoveNameFromResponses < ActiveRecord::Migration[7.1]
  def change
    remove_column :responses, :name, :string
  end
end
