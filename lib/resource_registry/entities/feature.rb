# frozen_string_literal: true

module ResourceRegistry
  class Feature < Dry::Struct

    # @!attribute [r] key (required)
    # ID for this Feature. Must be unique within a registry namespace (required)
    # @return [Symbol]
    attribute :key,         Types::Symbol.meta(omittable: false)

    attribute :namespace,   Types::Array.of(Types::RequiredSymbol).default([].freeze).meta(omittable: false)

    # @!attribute [r] is_required (required)
    # State of this Feature either enabled or disabled
    # @return [boolean]
    attribute :is_enabled,  Types::Bool.meta(omittable: false).default(false)

    # @!attribute [r] item (required)
    # Reference or code to be executed when this feature is invoked
    # @return [Any]
    attribute :item,        Types::Any.meta(omittable: true)

    # @!attribute [r] options (optional)
    # Options passed through for item execution 
    # The user-assigned values passed through for this configuratino setting
    # @return [Hash]
    attribute :options,     Types::Any.optional.meta(omittable: true)

    # @!attribute [r] meta (optional)
    # Configuration settings and attributes that support presenting and updatig their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,        ResourceRegistry::Meta.optional.meta(omittable: true)


    # @!attribute [r] settings (optional)
    # Configuration settings and values for this Feature
    # @return [Array<ResourceRegistry::Setting>]
    attribute :settings,    Types::Array.of(ResourceRegistry::Setting).optional.meta(omittable: true)

  end
end
