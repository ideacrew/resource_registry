module ResourceRegistry
  module Entities
    class Option < Dry::Struct

      include Enumerable
      include DryStructSetters

      transform_keys(&:to_sym)

      attribute :namespace?,   Types::Symbol
      attribute :key,          Types::Symbol

      # TODO: Make settings attribute dynamically typed
      attribute :settings,      Types::Array.meta(omittable: true) do 
        attribute :key,         Types::RequiredSymbol
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