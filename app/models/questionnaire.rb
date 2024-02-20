class Questionnaire < ApplicationRecord
  belongs_to :it_equipment
  has_and_belongs_to_many :questions
  has_many :answers
end
