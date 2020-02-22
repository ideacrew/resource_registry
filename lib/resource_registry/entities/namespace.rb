# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Namespace < Dry::Struct

      attribute :path,        Types::Array.of(Types::RequiredSymbol)

      # @!attribute [r] meta (optional)
      # Configuration settings and attributes that support presenting and updatig their values n the User Interface
      # @return [ResourceRegistry::Entities::Meta]
      attribute :meta,        ResourceRegistry::Entities::Meta.optional.meta(omittable: true)

      attribute :features,    Types::Array.of(ResourceRegistry::Entities::Feature).optional.meta(omittable: true)
    end
  end
end