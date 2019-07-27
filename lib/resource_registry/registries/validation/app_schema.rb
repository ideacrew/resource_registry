require 'i18n'
require 'dry/schema'

module ResourceRegistry
  module Registries
    module Validation
      class AppSchema < Dry::Schema::Params

        define do
          # config.messages.load_paths << '/my/app/config/locales/en.yml'
          config.messages.backend = :i18n
        end
      end
    end
  end
end