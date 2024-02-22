class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :questionnaire
  has_one_attached :photo

  validates :response, :question, :user, :questionnaire, presence: true
end
