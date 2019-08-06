require 'resource_registry/tenants/validation/tenant_contract'

module ResourceRegistry
  module Options
    module Validation

      EnterpriseContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do

          optional(:tenants).array(:hash) do
            optional(:tenant).value(type?: ResourceRegistry::Tenants::Validation::TenantContract)
          end

          optional(:features).array(:hash) do
            optional(:feature).value(type?: ResourceRegistry::Features::Validation::FeatureContract)
          end

        end
      end

    end
  end
end