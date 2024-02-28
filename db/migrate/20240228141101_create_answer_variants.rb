class CreateAnswerVariants < ActiveRecord::Migration[7.1]
  def change
    create_table :answer_variants do |t|
      t.string :name
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
