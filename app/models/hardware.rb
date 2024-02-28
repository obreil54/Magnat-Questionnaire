class Hardware < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category_hard
  has_many :response_details, dependent: :destroy

  validates :model, :series, presence: true
  validates :user, :loaned_at, presence: true, if: -> { status == true }

  before_save :clear_user_and_loan_date

  private

  def clear_user_and_loan_date
    self.user_id = nil unless status
    self.loaned_at = nil unless status
  end
end
