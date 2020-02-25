# frozen_string_literal: true

module ResourceRegistry
  class Feature < Dry::Struct

    # @!attribute [r] key (required)
    # ID for this Feature. Must be unique within a registry namespace (required)
    # @return [Symbol]
    attribute :key,         Types::Symbol.meta(omittable: false)

    attribute :namespace,   Types::Array.of(Types::RequiredSymbol).meta(omittable: false)

    # @!attribute [r] is_required (required)
    # State of this Feature either enabled or disabled
    # @return [boolean]
    attribute :is_enabled,  Types::Bool.meta(omittable: false)

    # @!attribute [r] meta (optional)
    # Configuration settings and attributes that support presenting and updatig their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,        ResourceRegistry::Meta.optional.meta(omittable: true)


    # @!attribute [r] settings (optional)
    # Configuration settings and values for this Feature
    # @return [Array<ResourceRegistry::Setting>]
    attribute :settings,    Types::Array.of(ResourceRegistry::Setting).meta(omittable: true)

  end
end
