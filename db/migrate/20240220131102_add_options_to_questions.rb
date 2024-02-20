class AddOptionsToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :options, :text, array: true, default: []
  end
end
