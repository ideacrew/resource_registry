# frozen_string_literal: true

module ResourceRegistry
  module Entities

    class Feature < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,         Types::RequiredSymbol
      attribute :is_required, Types::Bool.optional
      attribute :is_enabled,  Types::Bool.optional
      attribute :alt_key,     Types::Symbol.optional.meta(omittable: true)
      attribute :title,       Types::String.optional.meta(omittable: true)
      attribute :description, Types::String.optional.meta(omittable: true)
      # attribute :registry,      Types::String.optional.meta(omittable: true)
      attribute :options,     Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)
      attribute :features,    Types::Array.of(ResourceRegistry::Entities::Feature).meta(omittable: true)
    end
  end
end