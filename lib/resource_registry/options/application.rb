module ResourceRegistry
  module Options
    # An Application is all code operating under a single process
    class Application < Dry::Struct # EA, EDI DB, Ledger
      
      transform_keys(&:to_sym)

      attribute :key,               Types::Symbol
      attribute :title?,            Types::Strict::String
      attribute :description?,      Types::Strict::String
      attribute :dependency_keys?,  Types::Array
      attribute :feature_keys?,     Types::Array

      # attribute :container_key,   Types::Symbol

      # attribute :tenant_application_subscription_keys, Types::Array
      # attribute :option_group_keys, Types::Array
    end
  end
end