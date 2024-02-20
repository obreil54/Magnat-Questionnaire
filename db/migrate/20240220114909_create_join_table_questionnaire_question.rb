class CreateJoinTableQuestionnaireQuestion < ActiveRecord::Migration[7.1]
  def change
    create_join_table :questionnaires, :questions do |t|
      t.index [:questionnaire_id, :question_id]
      t.index [:question_id, :questionnaire_id]
    end
  end
end
