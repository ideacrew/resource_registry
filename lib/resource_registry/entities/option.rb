# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Option < Dry::Struct

      attribute :key,           Types::RequiredSymbol

      attribute :settings,      Types::Array.meta(omittable: true).default([].freeze) do
        # attribute :key,         Types::String # This need to made Symbol. Contracts rules are validating but not returning coerced values for nested entities.
        attribute :default,     Types::Strict::Any
        attribute :title,       Types::String.optional.meta(omittable: true)
        attribute :description, Types::String.optional.meta(omittable: true)
        attribute :type,        Types::Symbol.optional.meta(omittable: true)
        attribute :value,       Types::Any.optional.meta(omittable: true)
        attribute :options,     Types::Array.of(ResourceRegistry::Entities::Option).optional.meta(omittable: true)
      end
    end
  end
end