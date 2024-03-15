class AnswerVariant < ApplicationRecord
  has_many :selected_answer_variants, dependent: :destroy
  has_many :questions, through: :selected_answer_variants

  validates :name, presence: true
end
