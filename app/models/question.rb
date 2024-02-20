class Question < ApplicationRecord
  has_and_belongs_to_many :questionnaires
  has_many :answers

  validates :content, :question_type, presence: true
  validates :question_type, inclusion: { in: %w[text select photo] }
end
