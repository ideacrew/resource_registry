# frozen_string_literal: true

module ResourceRegistry
  module Entities
    # rubocop:disable Style/RescueModifier
    OptionConstructor = Types.Constructor("Option") { |val| Option.new(val) rescue nil }
    # rubocop:enable Style/RescueModifier

    class Option
      extend Dry::Initializer

      option :namespace,      optional: true
      option :key
      option :namespaces,     type: Dry::Types['coercible.array'].of(OptionConstructor), optional: true, default: -> { [] }

      option :settings, [],   optional: true do
        option :key
        option :title,        optional: true
        option :description,  optional: true
        option :type,         optional: true
        option :default
        option :value,        optional: true
      end
    end
  end
end