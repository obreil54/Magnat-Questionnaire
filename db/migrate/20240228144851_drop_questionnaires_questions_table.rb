class DropQuestionnairesQuestionsTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :questionnaires_questions
  end
end
