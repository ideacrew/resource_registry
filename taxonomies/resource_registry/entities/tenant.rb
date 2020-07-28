# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Tenant < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key, Types::RequiredSymbol
      attribute :owner_organization_name,  Types::String.optional.meta(omittable: true)
      attribute :owner_account_name,       Types::String.optional.meta(omittable: true)
      attribute :options,       Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)

      attribute :subscriptions,      Types::Array.meta(omittable: true).default([]) do
        attribute :feature_key, Types::RequiredSymbol
        attribute :id,                     Types::String.optional
        attribute :validator_id,           Types::String.optional
        attribute :subscribed_at,          Types::String.optional
        attribute :unsubscribed_at,        Types::String.optional
        attribute :options,      Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)
      end

      attribute :sites,      Types::Array.meta(omittable: true) do
        attribute :key,                    Types::RequiredSymbol
        attribute :url,                    Types::String.optional.meta(omittable: true)
        attribute :title,                  Types::String.optional.meta(omittable: true)
        attribute :description,            Types::String.optional.meta(omittable: true)
        attribute :options,      Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)

        attribute :environments,      Types::Array.meta(omittable: true) do
          attribute :key, Types::RequiredSymbol
          attribute :options,    Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)
          attribute :features,   Types::Array.of(ResourceRegistry::Entities::Feature).meta(omittable: true)
        end
      end
    end
  end
end
