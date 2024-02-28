class AnswerVariant < ApplicationRecord
  belongs_to :question

  validates :name, presence: true
end
