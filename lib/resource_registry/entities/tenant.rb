module ResourceRegistry
  module Entities
    
    TenantConstructor = Types.Constructor("Tenant") { |val| Tenant.new(val) rescue nil }

    class Tenant
      extend Dry::Initializer
      
      option :key
      option :owner_organization_name,  optional: true
      option :owner_account_name,       optional: true

      option :subscriptions, [], optional: true do
        option :feature_key
        option :id,               optional: true
        option :validator_id,     optional: true

        option :subscribed_at
        option :unsubscribed_at,  optional: true
      end

      option :sites, [], optional: true do 
        option :key
        option :url,          optional: true
        option :title,        optional: true
        option :description,  optional: true

        option :environments, [], optional: true do
          option :key
          option :is_enabled
          option :registry,   optional: true #,   type: Dry::Types::Array.of(RegistryConstructor), optional: true
          option :options,    type: Dry::Types['coercible.array'].of(ResourceRegistry::Entities::OptionConstructor), optional: true, default: -> { [] }
          option :features,   type: Dry::Types['coercible.array'].of(ResourceRegistry::Entities::FeatureConstructor), optional: true, default: -> { [] }
        end
      end

      def each
        sites.each { |site| yield site }
      end
    end
  end
end