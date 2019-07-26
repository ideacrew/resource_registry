require 'dry/schema'

class AppSchema < Dry::Schema::Params
  # config.messages.load_paths << '/my/app/config/locales/en.yml'
  config.messages.backend = :i18n

  define do
    # define common rules, if any
  end
end