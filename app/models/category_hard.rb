class CategoryHard < ApplicationRecord
  has_many :hardwares
  has_many :questions, dependent: :destroy
  validates :name, presence: true
end
