# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Enterprise
      extend Dry::Initializer

      option :owner_organization_name,  optional: true
      option :owner_account_name,       optional: true
      option :tenants, type: Dry::Types['coercible.array'].of(TenantConstructor), optional: true, default: -> { [] }
      option :options, type: Dry::Types['coercible.array'].of(ResourceRegistry::Entities::OptionConstructor), optional: true, default: -> { [] }

    end
  end
end