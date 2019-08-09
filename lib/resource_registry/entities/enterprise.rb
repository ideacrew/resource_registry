module ResourceRegistry
  module Entities
    class Enterprise
      extend Dry::Initializer

      option :owner_organization_name,  optional: true
      option :owner_account_name,       optional: true

      option :tenants, [], optional: true do
        option :tenant, optional: true
      end
    end
  end
end