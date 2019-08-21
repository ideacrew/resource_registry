# frozen_string_literal: true

module ResourceRegistry
  module Entities
    # rubocop:disable Style/RescueModifier
    FeatureConstructor = Types.Constructor("Feature") { |val| Feature.new(val) rescue nil }
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
      option :options,        type: Dry::Types['coercible.array'].of(ResourceRegistry::Entities::OptionConstructor), optional: true, default: -> { [] }
      option :features,       type: Dry::Types['coercible.array'].of(ResourceRegistry::Entities::FeatureConstructor), optional: true, default: -> { [] }

    end
  end
end