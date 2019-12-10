# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Option < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,            Types::RequiredSymbol
      attribute :namespaces,     Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)

      attribute :settings,       Types::Array.meta(omittable: true).default([]) do
        attribute :key,          Types::String # This need to made Symbol. Contracts rules are validating but not returning coerced values for nested entities.
        attribute :title,        Types::String.optional.meta(omittable: true)
        attribute :description,  Types::String.optional.meta(omittable: true)
        attribute :choices,      Types::Array.optional.meta(omittable: true)
        attribute :type,         Types::Symbol.optional.meta(omittable: true)
        attribute :default,      Types::Strict::Any
        attribute :value,        Types::Any.optional.meta(omittable: true)
      end
    end
  end
end