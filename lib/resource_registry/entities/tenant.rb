module ResourceRegistry
  module Entities
    class Tenant < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,                 Types::RequiredSymbol # tenant_key
      attribute :owner_organization_name,   ResourceRegistry::Entities::Setting
      attribute :owner_account_name,  ResourceRegistry::Entities::Setting

      attribute :sites, Types::Array.meta(omittable: true) do
        attribute :key,         Types::RequiredSymbol
        attribute :uri,         Types::String
        attribute :title,       Types::String.optional
        attribute :description, Types::String.optional
      end

      attribute :subscriptions, Types::Array.meta(omittable: true) do
        attribute :key,             Types::RequiredSymbol
        attribute :id,              Types::String.optional
        attribute :validator_id,    Types::String.optional

        attribute :subscribed_at,   Types::DateTime.optional
        attribute :unsubscribed_at, Types::DateTime.optional
      end

      # attribute :subscriptions, Types::Array.of(ResourceRegistry::Entities::Subscription).meta(omittable: true)
      attribute :features, Types::Array.of(ResourceRegistry::Entities::Feature).meta(omittable: true)
    end
  end
end