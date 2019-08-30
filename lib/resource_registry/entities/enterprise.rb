# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Enterprise
      extend Dry::Initializer

      option :owner_organization_name,  optional: true
      option :owner_account_name,       optional: true
      option :tenants, type: Types::Array.of(TenantConstructor), optional: true
      option :options, type: Types::Array.of(ResourceRegistry::Entities::OptionConstructor), optional: true

    end
  end
end