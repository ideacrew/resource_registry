# frozen_string_literal: true

module ResourceRegistry
  class Setting < Dry::Struct

    # @!attribute [r] key (required)
    # ID for this Feature. Must be unique within a registry namespace (required)
    # @return [Symbol]
    attribute :key,     Types::RequiredSymbol

    # @!attribute [r] item (required)
    # The user-assigned value for this configuratino setting
    # @return [Any]
    attribute :item,    Types::Any.meta(omittable: false)

    # @!attribute [r] options (optional)
    # Options passed through for this setting 
    # The user-assigned value for this configuratino setting
    # @return [Hash]
    attribute :options, Types::Any.optional.meta(omittable: true)

    attribute :meta,    ResourceRegistry::Meta.optional.meta(omittable: true)
  end
end
