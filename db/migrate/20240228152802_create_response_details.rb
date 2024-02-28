class CreateResponseDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :response_details do |t|
      t.references :response, null: false, foreign_key: true
      t.references :hardware, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :answer

      t.timestamps
    end
  end
end
