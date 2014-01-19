require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Shoes
  class Application < Rails::Application
    require "#{ config.root }/app/models/settings"
    config.autoload_paths += %W(#{ config.root }/lib/crawler #{ config.root }/app/workers)
    config.active_record.timestamped_migrations = false

    config.action_controller.page_cache_directory = "#{ Rails.root }/public/cache"
    config.action_controller.default_url_options = { trailing_slash: true }

    config.action_mailer.default_url_options = { host: Settings.domain, trailing_slash: true }
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: Settings.email.domain,
      user_name: Settings.email.user_name,
      password: Settings.email.password,
      authentication: 'plain',
      enable_starttls_auto: true
    }
  end
end