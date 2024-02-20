class ItEquipment < ApplicationRecord
  belongs_to :user, optional: true
  has_many :equipment_questionnaires, dependent: :destroy
  has_many :questionnaires, through: :equipment_questionnaires

  validates :category, :make, :model, :description, :status, presence: true
  validates :category, inclusion: { in: %w[laptop monitor keyboard mouse] }
end
