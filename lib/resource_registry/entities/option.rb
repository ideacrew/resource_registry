module ResourceRegistry
  module Entities
    class Option < Dry::Struct
      transform_keys(&:to_sym)

      include Enumerable
      include DryStructSetters

      attribute :namespace?,   Types::Coercible::Symbol
      attribute :key,          Types::Coercible::Symbol
      attribute :alt_key,      Types::Coercible::Symbol.meta(omittable: true)

      # TODO: Make settings attribute dynamically typed
      attribute :settings,      Types::Array.meta(omittable: true) do 
        attribute :key,         Types::RequiredSymbol
        attribute :alt_key,     Types::Coercible::Symbol.meta(omittable: true)
        attribute :title,       Types::String.optional
        attribute :description, Types::String.optional

        attribute :type,        Types::Symbol.optional
        attribute :default,     Types::Any
        attribute :value,       Types::Any.optional
      end

      attribute :namespaces?, Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)

    end
  end
end