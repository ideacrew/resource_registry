# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Enterprise < Dry::Struct
      transform_keys(&:to_sym)

      attribute :owner_organization_name,  Types::String.optional.meta(omittable: true)
      attribute :owner_account_name,       Types::String.optional.meta(omittable: true)
      attribute :tenants, Types::Array.of(ResourceRegistry::Entities::Tenant).meta(omittable: true) 
      attribute :options, Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true) 

    end
  end
end