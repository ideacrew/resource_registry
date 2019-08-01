module ResourceRegistry
  module Entities
    class Setting < Dry::Struct
      include DryStructSetters
      transform_keys(&:to_sym)

      attribute :key,         Types::RequiredSymbol
      attribute :title,       Types::String.optional
      attribute :description, Types::String.optional

      attribute :type,        Types::Symbol.optional
      attribute :default,     Types::Any
      attribute :value,       Types::Any.optional

    end
  end
end