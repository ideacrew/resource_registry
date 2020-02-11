# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Feature < Dry::Struct

      attribute :key,         Types::Symbol.meta(omittable: false)
      attribute :parent_key,  Types::Symbol.meta(omittable: false)
      attribute :is_required, Types::Bool.meta(omittable: false)
      attribute :is_enabled,  Types::Bool.meta(omittable: false)
      attribute :ui_metadata, ResourceRegistry::Entities::UiMetadata.optional.meta(omittable: true)
      attribute :authorization_policies,  Types::Array.of(ResourceRegistry::Entities::AuthorizationPolicy).meta(omittable: true)
      attribute :options,     Types::Array.of(ResourceRegistry::Entities::Option).meta(omittable: true)
      attribute :features,    Types::Array.of(ResourceRegistry::Entities::Feature).meta(omittable: true)
    end
  end
end
