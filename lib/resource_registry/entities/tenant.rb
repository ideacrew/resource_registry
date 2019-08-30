# frozen_string_literal: true

module ResourceRegistry
  module Entities
    # rubocop:disable Style/RescueModifier
    TenantConstructor = Types.Constructor("Tenant") { |val| Tenant.new(val) }
    # rubocop:enable Style/RescueModifier

    class Tenant
      extend Dry::Initializer

      option :key
      option :owner_organization_name,  optional: true
      option :owner_account_name,       optional: true
      option :options,        type: Types::Array.of(ResourceRegistry::Entities::OptionConstructor), optional: true

      option :subscriptions, [], optional: true do
        option :feature_key
        option :id,                     optional: true
        option :validator_id,           optional: true
        option :subscribed_at
        option :unsubscribed_at,        optional: true
        option :options,      type: Types::Array.of(ResourceRegistry::Entities::OptionConstructor), optional: true
      end

      option :sites, [], optional: true do
        option :key
        option :url,                    optional: true
        option :title,                  optional: true
        option :description,            optional: true
        option :options,      type: Types::Array.of(ResourceRegistry::Entities::OptionConstructor), optional: true

        option :environments, [], optional: true do
          option :key
          option :options,    type: Types::Array.of(ResourceRegistry::Entities::OptionConstructor), optional: true
          option :features,   type: Types::Array.of(ResourceRegistry::Entities::FeatureConstructor), optional: true
        end
      end
    end
  end
end