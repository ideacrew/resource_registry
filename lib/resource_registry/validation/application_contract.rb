require 'dry/validation'

module ResourceRegistry
  module Validation
    class ApplicationContract < Dry::Validation::Contract
      config.messages.default_locale = :en

# config.messages.top_namespace - the key in the locale files under which messages are defined, by default it’s dry_validation
# config.messages.backend - the localization backend to use. Supported values are: :yaml and :i18n
# config.messages.load_paths - an array of files paths that are used to load messages
# config.messages.namespace - custom messages namespace for a contract class. Use this to differentiate common messages
# config.messages.default_locale - default I18n-compatible locale identifier

    end
  end
end