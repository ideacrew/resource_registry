# frozen_string_literal: true

module ResourceRegistry
  class Feature < Dry::Struct

    # @!attribute [r] key (required)
    # Identifier for this Feature. Must be unique within a registry namespace
    # @return [Symbol]
    attribute :key,         Types::Symbol.meta(omittable: false)

    attribute :namespace,   Types::Array.of(Types::RequiredSymbol).default([].freeze).meta(omittable: false)

    # @!attribute [r] is_enabled  (required)
    # Availability state of this Feature in the application: either enabled or disabled
    # @return [true] If feature is enabled
    # @return [false] If feature is disabled
    attribute :is_enabled,  Types::Bool.default(false).meta(omittable: false)

    # @!attribute [r] item (required)
    # The reference or code to be evaluated when feature is resolved
    # @return [Any]
    attribute :item,        Types::Any.meta(omittable: true)

    # @!attribute [r] options 
    # Options passed through for item execution 
    # The user-assigned values passed through for this configuratino setting
    # @return [Hash]
    attribute :options,     Types::Any.meta(omittable: true)

    # @!attribute [r] meta (optional)
    # Configuration settings and attributes that support presenting and updating their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,        ResourceRegistry::Meta.default(Hash.new.freeze).meta(omittable: true)

    # @!attribute [r] settings (optional)
    # Configuration settings and values for this Feature
    # @return [Array<ResourceRegistry::Setting>]
    attribute :settings,    Types::Array.of(ResourceRegistry::Setting).default([].freeze).meta(omittable: true)

  end
end
