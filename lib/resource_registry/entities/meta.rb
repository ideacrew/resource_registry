# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Meta < Dry::Struct

      attribute :title,       Types::String.meta(omittable: false)
      attribute :type,        Types::Symbol.meta(omittable: false)
      attribute :default,     Types::Any.meta(omittable: false)
      attribute :value,       Types::Any.optional.meta(omittable: true)
      attribute :description, Types::String.optional.meta(omittable: true)
      attribute :choices,     Types::Array.of(Types::Any).optional.meta(omittable: true)
      attribute :is_required, Types::Bool.optional.meta(omittable: true)
      attribute :is_visible,  Types::Bool.optional.meta(omittable: true)

    end
  end
end
