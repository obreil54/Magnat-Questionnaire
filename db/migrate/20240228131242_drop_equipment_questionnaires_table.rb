class DropEquipmentQuestionnairesTable < ActiveRecord::Migration[7.1]
  def change
    drop_table :equipment_questionnaires do |t|
      t.bigint "equipment_id", null: false
      t.bigint "questionnaire_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["it_equipment_id"], name: "index_equipment_questionnaires_on_it_equipment_id"
      t.idex ["questionnaire_id"], name: "index_equipment_questionnaires_on_questionnaire_id"
    end
  end
end
