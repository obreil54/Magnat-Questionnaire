class AddNotNullToBooleanColumnsInQuestions < ActiveRecord::Migration[7.1]
  def change
    change_column :questions, :required, :boolean, null: false, default: true
    change_column :questions, :status, :boolean, null: false, default: true
  end
end
