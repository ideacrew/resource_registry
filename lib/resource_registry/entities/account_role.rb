# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class AccountRole < Dry::Struct

      attribute :key,         Types::Symbol.meta(omittable: false)
      attribute :title,       Types::String.meta(omittable: false)
      attribute :description, Types::String.meta(omittable: true)
      attribute :is_active,   Types::Bool.meta(omittable: false)

    end
  end
end