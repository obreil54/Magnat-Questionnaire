class CreateCategoryHard < ActiveRecord::Migration[7.1]
  def change
    create_table :category_hards do |t|

      t.timestamps
    end
  end
end
