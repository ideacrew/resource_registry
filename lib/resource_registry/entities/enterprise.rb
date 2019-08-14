module ResourceRegistry
  module Entities
    
    class Enterprise
      extend Dry::Initializer

      option :owner_organization_name,  optional: true
      option :owner_account_name,       optional: true
      option :tenants, type: Dry::Types['coercible.array'].of(TenantConstructor), optional: true, default: -> { [] }
      
      option :features, [], optional: true do
        option :feature, optional: true
      end
    end
  end
end