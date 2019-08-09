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

        rule(:tenants).each do
          validation_errors = []
            result = ResourceRegistry::Tenants::Validation::TenantContract.call(value)

            if result && result.failure?
              validation_errors << result.errors.messages.reduce([]) do |list, message|
                list << [{ path: message.path }, { input: message.input.to_s }, { text: message.text.to_s }]
              end
            end          

          key.failure("validation failed: #{validation_errors.flatten}") if validation_errors.size > 0
        end

      end

    end
  end
end