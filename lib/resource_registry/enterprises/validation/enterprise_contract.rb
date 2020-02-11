# frozen_string_literal: true

module ResourceRegistry
  module Enterprises
    module Validation
      class EnterpriseContract < ResourceRegistry::Validation::ApplicationContract

        params do
          optional(:key).maybe(:symbol)
          optional(:owner_organization_name).maybe(:string)
          optional(:owner_account_name).maybe(:string)
          optional(:tenants).array(:hash)
          optional(:options).array(:hash)
        end

      end
    end
  end
end