class Question < ApplicationRecord
  has_many :selected_answer_variants, dependent: :destroy
  has_many :answer_variants, through: :selected_answer_variants
  has_many :response_details, dependent: :destroy
  belongs_to :question_type
  belongs_to :category_hard

  validates :name, :question_type, :category_hard, presence: true
  validates :required, inclusion: { in: [true, false] }
end
