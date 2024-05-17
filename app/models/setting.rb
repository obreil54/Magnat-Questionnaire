class Setting < ApplicationRecord
  validates :settingname, presence: true, uniqueness: true

  def self.email_system_name
    setting = find_by(settingname: "email_system_name")
    if setting&.settingvalue.present?
      setting.settingvalue
    else
      nil
    end
  end
end
