class CreateSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :settings do |t|
      t.string :settingname, null: false
      t.string :settingvalue
      t.string :comment

      t.timestamps
    end

    add_index :settings, :settingname, unique: true
  end
end
