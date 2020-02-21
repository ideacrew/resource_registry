# frozen_string_literal: true

module ResourceRegistry
  module Entities

    # The Enterprise is the top-level namespace for a single domain.  A domain includes tenant organizations
    # along with their respective sites, environments, features and settings
    class Enterprise < Dry::Struct

      # @!attribute [r] key
      # Unique ID for enterprise administering this domain (required)
      # @return [Symbol]
      attribute :key,                     Types::Symbol.meta(omittable: false)

      # @!attribute [r] owner_account
      # Reference to Super Admin account for this domain (required)
      # @return [String]
      attribute :owner_account,           Types::String.meta(omittable: false)

      # @!attribute [r] owner_organization_name
      # Title for organization adminstering this domain (optional)
      # @return [String]
      attribute :organization_name,       Types::String.optional.meta(omittable: true)


      # @!attribute [r] tenants
      # Tenant organizations supported by this domain (optional)
      # @return [Array<ResourceRegistry::Entities::Tenant>]
      attribute :tenants,                 Types::Array.of(ResourceRegistry::Entities::Tenant).meta(omittable: true) 

      # @!attribute [r] options
      # Enterprise-level settings (optional)
      # @return [Array<ResourceRegistry::Entities::Option>]
      attribute :meta,                    Types::Array.of(ResourceRegistry::Entities::Meta).meta(omittable: true) 

    end
  end
end