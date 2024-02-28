class UpdateQuestionnairesTable < ActiveRecord::Migration[7.1]
  def change
    rename_column :questionnaires, :title, :name

    add_column :questionnaires, :start_date, :date
    add_column :questionnaires, :end_date, :date

    remove_column :questionnaires, :description, :text

    add_column :questionnaires, :status, :boolean, default: false
  end
end
