class Setting < ApplicationRecord
  validates :settingname, presence: true, uniqueness: true

  def self.email_system_name
    find_by(settingname: "email_system_name")&.settingvalue
  end

  def self.fileapi_url
    find_by(settingname: "fileapi_url")&.settingvalue
  end

  def self.fileapi_path
    find_by(settingname: "fileapi_path")&.settingvalue
  end

  def self.fileapi_token
    find_by(settingname: "fileapi_token")&.settingvalue
  end
end
