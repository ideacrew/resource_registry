module ResourceRegistry
  module Entities
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

          option :features, [], optional: true do
            option :feature, optional: true
          end
        end
      end

  end
end