class Questionnaire < ApplicationRecord
  has_many :equipment_questionnaires, dependent: :destroy
  has_many :it_equipments, through: :equipment_questionnaires
  has_and_belongs_to_many :questions
  has_many :answers

  validates :title, :description, presence: true
end
