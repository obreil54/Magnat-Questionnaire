require 'yaml'

Rails.application.config.to_prepare do

  storage_config_path = Rails.root.join('config', 'storage.yml')
  storage_config = YAML.load_file(storage_config_path).deep_symbolize_keys

  Rails.application.config.active_storage.service_configurations ||= storage_config

  custom_service_config = {
    service: "CustomFile",
    token: Setting.fileapi_token,
    base_url: Setting.fileapi_url
  }

  Rails.application.config.active_storage.service_configurations[:custom_service] = custom_service_config

  ActiveStorage::Blob.service = ActiveStorage::Service.configure(
    :custom_service,
    Rails.application.config.active_storage.service_configurations
  )

  ActiveStorage::Blob.class_eval do
    def purge_later
      CustomPurgeJob.perform_later(self)
    end
  end
end
