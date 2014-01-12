require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Shoes
  class Application < Rails::Application
    config.autoload_paths += %W(#{ config.root }/lib/crawler #{ config.root }/app/workers)
    config.active_record.timestamped_migrations = false
    config.action_mailer.smtp_settings = {
      address: 'smtp.gmail.com',
      port: 587,
      domain: 'buscasapato.com.br',
      user_name: 'contato@buscasapato.com.br',
      password: 'xsbi3JHnK9mTo',
      authentication: 'plain',
      enable_starttls_auto: true
    }
  end
end