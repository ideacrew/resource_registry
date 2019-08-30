# frozen_string_literal: true

module ResourceRegistry
  module Entities
    # rubocop:disable Style/RescueModifier
    FeatureConstructor = Types.Constructor("Feature") { |val| Feature.new(val) }
    # rubocop:enable Style/RescueModifier

    class Feature
      extend Dry::Initializer

      option :key
      option :is_required
      option :is_enabled
      option :alt_key,        optional: true
      option :title,          optional: true
      option :description,    optional: true
      option :registry,       optional: true
      option :options,        type: Types::Array.of(ResourceRegistry::Entities::OptionConstructor), optional: true
      option :features,       type: Types::Array.of(ResourceRegistry::Entities::FeatureConstructor), optional: true

    end
  end
end