# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'models', '*.{rb,yml}')]

I18n.available_locales = :pt
I18n.default_locale = :pt
