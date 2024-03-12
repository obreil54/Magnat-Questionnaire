RailsAdmin.config do |config|
  config.actions do
    all
    import
  end

  config.configure_with(:import) do |config|
    config.update_if_exists = true
    config.rollback_on_error = true
  end

  config.model 'User' do
    import do
      include_all_fields
      exclude_fields :id, :created_at, :updated_at, :log_in_code, :remember_digest, :admin, :hardwares, :responses
      mapping_key :code
      mapping_key_list [:code]
    end
  end

  config.model 'Hardware' do
    import do
      include_all_fields
      exclude_fields :id, :created_at, :updated_at, :response_details
      mapping_key :code
      mapping_key_list [:code]
    end
  end
end
