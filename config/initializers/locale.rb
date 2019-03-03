# frozen_string_literal: true

# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'models', '*.{rb,yml}')]

I18n.available_locales = %i[pt-BR en]
I18n.default_locale = :'pt-BR'
