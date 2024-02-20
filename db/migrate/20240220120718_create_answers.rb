class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.text :response
      t.references :question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :questionnaire, null: false, foreign_key: true

      t.timestamps
    end
  end
end
