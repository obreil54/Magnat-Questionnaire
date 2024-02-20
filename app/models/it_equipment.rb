class ItEquipment < ApplicationRecord
  belongs_to :user, optional: true
end
