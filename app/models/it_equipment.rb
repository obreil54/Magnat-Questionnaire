class ItEquipment < ApplicationRecord
  belongs_to :user, optional: true
  has_many :equipment_questionnaires, dependent: :destroy
  has_many :questionnaires, through: :equipment_questionnaires

  validates :category, :make, :model, :description, presence: true
  validates :category, inclusion: { in: %w[laptop monitor keyboard mouse] }
  validates :user, :loaned_at, presence: true, if: -> { status == true }

  before_save :clear_user_and_loan_date

  private

  def clear_user_and_loan_date
    self.user_id = nil unless status
    self.loaned_at = nil unless status
  end
end
