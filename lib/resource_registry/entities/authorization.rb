# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Authorization < Dry::Struct

      attribute :user,    Types::Symbol.meta(omittable: false)
      attribute :domain,  Types::Array.of(Symbol).meta(omittable: false)
    end
  end
end