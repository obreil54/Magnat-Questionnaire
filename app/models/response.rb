class Response < ApplicationRecord
  belongs_to :user
  belongs_to :questionnaire
  has_many :response_details, dependent: :destroy

  validates :user, :questionnaire, presence: true
end
