class ItEquipment < ApplicationRecord
  belongs_to :user, optional: true
  has_many :equipment_questionnaires, dependent: :destroy
  has_many :questionnaires, through: :equipment_questionnaires
end
