class CreateEquipmentQuestionnaires < ActiveRecord::Migration[7.1]
  def change
    create_table :equipment_questionnaires do |t|
      t.references :it_equipment, null: false, foreign_key: true
      t.references :questionnaire, null: false, foreign_key: true

      t.timestamps
    end
  end
end
