require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module MagnatQuestionnaire
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.helper false
      generate.test_framework :test_unit, fixture: false
    end

    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    config.i18n.fallbacks = {ru: [:en]}
    config.i18n.available_locales = %i[en ru]
    config.i18n.default_locale = :ru
    config.time_zone = "Europe/Moscow"
    config.active_record.default_timezone = :local
  end
end
