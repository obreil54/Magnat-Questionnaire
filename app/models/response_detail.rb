class ResponseDetail < ApplicationRecord
  belongs_to :response
  belongs_to :question
  belongs_to :hardware
  has_one_attached :image

  validates :response, :hardware, :question, presence: true
  validates :answer, presence: true, if: -> { question.required? }

end
