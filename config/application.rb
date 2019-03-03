# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Imo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # config.api_only = false
    config.autoload_paths += %W[#{config.root}/lib #{config.root}/app/admin/helpers #{config.root}/lib/concerns #{config.root}/app/serializers/concerns]
    config.time_zone = 'Brasilia'
    config.encoding = 'utf-8'
    config.to_prepare { Devise::Mailer.layout 'mail' }
    # config.active_record.raise_in_transactional_callbacks = true
    # config.assets.precompile += [
    #   'active_admin/admin.js',
    #   'admin/sisbacen.css',
    #   'admin/requirers/receipt.css',
    #   'admin/operations/receipt.css', 'admin/operations/reconciliation.css',
    #   'documents/operation/credit_data.css', 'documents/operation/reconciliation.css',
    #   'documents/operation/requirer_loan_receipt.css',
    #   'documents/portfolio/contracts_report.css',
    #   'documents/portfolio/reconciliation.css',
    #   'documents/requirer/registration_file.css',
    #   'documents/investment_receipt.css',
    #   'documents/investment_registration_file.css',
    #   'document.css'
    # ]

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exist?(env_file)
        YAML.safe_load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end
  end
end
