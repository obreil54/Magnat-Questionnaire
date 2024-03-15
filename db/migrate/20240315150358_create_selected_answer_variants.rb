class CreateSelectedAnswerVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :selected_answer_variants do |t|
      t.references :answer_variant, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
