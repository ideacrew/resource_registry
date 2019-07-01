require 'dry-struct'

module ResourceRegistry
    class Setting < Dry::Struct

      attribute :key,         Types::Symbol
      attribute :title,       Types::String
      attribute :description, Types::Strict::String
      attribute :type,        Types::Symbol
      attribute :value,       Types::Coercible::String
      attribute :default,     Types::Coercible::String

    end
end
