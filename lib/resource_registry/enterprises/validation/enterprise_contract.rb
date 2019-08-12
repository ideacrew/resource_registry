require 'resource_registry/tenants/validation/tenant_contract'

module ResourceRegistry
  module Enterprises
    module Validation

      EnterpriseContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do

          optional(:owner_organization_name).value(:string)
          optional(:owner_account_name).value(:string)

          optional(:tenants).array(:hash)
        end

      end

    end
  end
end