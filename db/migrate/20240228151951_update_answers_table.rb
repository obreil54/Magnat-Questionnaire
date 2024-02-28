class UpdateAnswersTable < ActiveRecord::Migration[7.1]
  def change
    rename_table :answers, :responses

    rename_column :responses, :response, :name
    change_column :responses, :name, :string

    remove_column :responses, :question_id

    add_column :responses, :end_date, :date
  end
end
