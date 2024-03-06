class AddNotNullToStatusInQuestionnaire < ActiveRecord::Migration[7.1]
  def change
    change_column :questionnaires, :status, :boolean, null: false, default: false
  end
end
