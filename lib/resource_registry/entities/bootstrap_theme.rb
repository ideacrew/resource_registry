# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class BootstrapTheme
      extend Dry::Initializer

      option :sass_options, [], optional: true do
      end

      option :colors, [], optional: true do
        option :primary,    optional: true, default: -> { '#3ec89d' }
        option :secondary,  optional: true, default: -> { '#3ab7ff' }
        option :success,    optional: true, default: -> { '#65ff9f' }
        option :info,       optional: true, default: -> { '#7164ff' }
        option :warning,    optional: true, default: -> { '#ff9f65' }
        option :danger,     optional: true, default: -> { '#ff457b' }
        option :light,      optional: true, default: -> { '#f2d4ff' }
        option :dark,       optional: true, default: -> { '#18181d' }
      end

      option :components, [], optional: true do
      end

      option :css_variables, [], optional: true do
      end
      end
  end
end
