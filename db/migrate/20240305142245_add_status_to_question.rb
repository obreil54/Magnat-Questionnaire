class AddStatusToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :status, :boolean
  end
end
