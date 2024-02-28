class ModifyQuestions < ActiveRecord::Migration[7.1]
  def change
    rename_column :questions, :content, :name

    add_column :questions, :category_hard_id, :bigint
    add_column :questions, :question_type_id, :bigint

    remove_column :questions, :question_type, :string
    remove_column :questions, :options, :text

    add_column :questions, :required, :boolean, default: true

    add_index :questions, :category_hard_id
    add_index :questions, :question_type_id

    add_foreign_key :questions, :category_hards
    add_foreign_key :questions, :question_types
  end
end
