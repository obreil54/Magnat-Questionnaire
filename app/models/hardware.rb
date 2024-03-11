class Hardware < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category_hard
  has_many :response_details, dependent: :destroy

  validates :model, :series, :category_hard, presence: true

  before_save :clear_user

  private

  def clear_user
    self.user_id = nil unless status
  end
end
