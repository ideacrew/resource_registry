# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Option < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,            Types::RequiredSymbol
      attribute :namespace,      Types::String.optional.meta(omittable: true)
      attribute :namespaces,     Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)

      attribute :settings,       Types::Array.meta(omittable: true).default([]) do
        attribute :key,          Types::String
        attribute :title,        Types::String.optional.meta(omittable: true)
        attribute :description,  Types::String.optional.meta(omittable: true)
        attribute :options,      Types::Array.optional.meta(omittable: true)
        attribute :type,         Types::Symbol.optional.meta(omittable: true)
        attribute :default,      Types::Any
        attribute :value,        Types::String.optional.meta(omittable: true)
      end
    end
  end
end
