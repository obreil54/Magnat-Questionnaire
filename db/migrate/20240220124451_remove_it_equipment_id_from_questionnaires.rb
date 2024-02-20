class RemoveItEquipmentIdFromQuestionnaires < ActiveRecord::Migration[7.1]
  def change
    remove_reference :questionnaires, :it_equipment, index: true, foreign_key: true
  end
end
