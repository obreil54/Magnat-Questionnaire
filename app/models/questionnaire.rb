class Questionnaire < ApplicationRecord
  has_many :responses

  validates :name, :start_date, :end_date, presence: true

  before_save :set_status_based_on_dates

  private

  def set_status_based_on_dates
    if start_date.present? && end_date.present?
      self.status = (start_date <= Date.today) && (end_date >= Date.today)
    else
      self.status = false
    end
  end
end
