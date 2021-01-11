# frozen_string_literal: true

module ResourceRegistry
  module Mongoid
    class Meta
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :label,         type: String
      field :content_type,  type: Symbol
      field :default,       type: String
      field :value,         type: String
      field :description,   type: String
      field :enum,          type: Array
      field :is_required,   type: Boolean
      field :is_visible,    type: Boolean

      embedded_in :metable, polymorphic: true

      def value_hash
        JSON.parse(value)
      end

      def value=(val)
        super(val.to_json)
      end
    end
  end
end
