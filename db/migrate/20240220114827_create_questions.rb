class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :content
      t.string :question_type

      t.timestamps
    end
  end
end
