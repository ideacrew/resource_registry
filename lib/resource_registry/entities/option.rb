# frozen_string_literal: true

module ResourceRegistry
  module Entities
    # rubocop:disable Style/RescueModifier
    OptionConstructor = Types.Constructor("Option") { |val| Option.new(val) }
    # rubocop:enable Style/RescueModifier

    class Option
      extend Dry::Initializer

      option :namespace,      optional: true
      option :key
      option :namespaces,     type: Types::Array.of(OptionConstructor), optional: true

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