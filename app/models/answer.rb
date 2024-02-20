class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :questionnaire

  validates :response, :question, :user, :questionnaire, presence: true
end
