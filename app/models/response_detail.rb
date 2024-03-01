class ResponseDetail < ApplicationRecord
  belongs_to :response
  belongs_to :question
  belongs_to :hardware
  has_one_attached :image

  # validates :answer, presence: { message: "Пожалуйста, дайте ответ на текущий вопрос." }
end
