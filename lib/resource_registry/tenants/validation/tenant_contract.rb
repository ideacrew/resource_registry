module ResourceRegistry
  module Tenants
    module Validation

      PrimarySiteType = Types::Symbol.default(:primary)

      TenantContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:key).value(:symbol)
          optional(:owner_organization_name).maybe(:string)
          optional(:owner_account_name).maybe(:string)

          optional(:subscriptions).array(:hash) do
            optional(:key).value(:symbol)
            optional(:id).maybe(:string)
            optional(:validator_id).maybe(:string)

            optional(:subscribed_at).maybe(Types::CallableDateTime)
            optional(:unsubscribed_at).maybe(type?: DateTime)
          end

          optional(:sites).array(:hash) do
            optional(:key).value(PrimarySiteType)
            optional(:url).maybe(type?: URI)
            optional(:title).maybe(:string)
            optional(:description).maybe(:string)

            optional(:features).array(:hash) do
              optional(:feature).filled(type?: ResourceRegistry::Features::Validation::FeatureContract)
            end          
          end
        end
      end

    end
  end
end
