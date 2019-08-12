module ResourceRegistry
  module Entities
    TenantConstructor = Types.Constructor("Tenant") { |val| Tenant.new(val) rescue nil }

    class Enterprise
      extend Dry::Initializer

      option :tenants, type: Dry::Types['coercible.array'].of(TenantConstructor), optional: true, default: -> { [] }

      option :features, [], optional: true do
        option :feature, optional: true
      end
    end
  end
end