class RemoveQuestionIdFromAnswerVariants < ActiveRecord::Migration[7.1]
  def change
    remove_column :answer_variants, :question_id, :bigint
  end
end
