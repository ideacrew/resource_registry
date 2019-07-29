module ResourceRegistry
  module Entities
    class Options  < Dry::Struct
      include Enumerable
      include DryStructSetters

      transform_keys(&:to_sym)

      # attribute :parent_namespace?, Types::Symbol
      attribute :namespace?,   Types::Symbol
      attribute :key,          Types::Symbol

      # TODO: Make settings attribute dynamically typed
      attribute :settings?,   Types::Array.of(Setting)
      attribute :namespaces?, Types::Array.of(Option)

    end
  end
end