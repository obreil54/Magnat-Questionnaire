class Hardware < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :category_hard
  has_many :response_details, dependent: :destroy

  validates :model, :series, :category_hard, :code, :user, presence: true

  class << self; attr_accessor :codes_imported; end

  def self.before_import
    self.codes_imported = []
  end

  def self.before_import_find(record)
    if record[:code].present? && record[:model].present? && record[:series].present? && record[:category_hard].present? && record[:user].present?
      return
    else
      raise ActiveRecord::RecordInvalid
    end
  end

  def after_import_save(record)
    self.class.codes_imported << record[:code] if record[:code].present?
  end

  def self.after_import
    Hardware.where.not(code: self.codes_imported).update_all(status: false)
  end
end
