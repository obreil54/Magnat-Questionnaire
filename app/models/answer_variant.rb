class AnswerVariant < ApplicationRecord
  belongs_to :question

  validates :name, :question, presence: true
end
