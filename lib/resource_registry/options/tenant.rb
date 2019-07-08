module ResourceRegistry
  module Options
    class Tenant < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,             Types::Symbol
      attribute :title?,          Types::Strict::String
      attribute :description?,    Types::Strict::String
      attribute :application_subscription_keys, Types::Array
    end

  end
end