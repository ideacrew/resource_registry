# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Portal < Dry::Struct
      attribute :key,         Types::RequiredSymbol
      attribute :environment, Types::Environment.meta(omittable: false)
      attribute :url,         Types::Url.optional.meta(omittable: true)

      attribute :title,       Types::String.optional.meta(omittable: true)
      attribute :description, Types::String.optional.meta(omittable: true)
      attribute :settings,    Types::Array.of(ResourceRegistry::Entities::Setting).meta(omittable: true)
    end
  end
end
