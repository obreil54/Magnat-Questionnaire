class QuestionType < ApplicationRecord
  has_many :questions

  validates :name, presence: true
  validates :name, inclusion: { in: ["Произвольный Ответ", "Выбор Значений", "Фото"] }
end
