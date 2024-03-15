class SelectedAnswerVariant < ApplicationRecord
  belongs_to :question
  belongs_to :answer_variant
end
