# frozen_string_literal: true
module ResourceRegistry
  module Mongoid
    class Setting
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :key,         type: Symbol
      field :options,     type: Array
      field :item,        type: String

      embeds_one :meta, as: :metable, class_name: '::ResourceRegistry::Mongoid::Meta', cascade_callbacks: true
      embedded_in :feature, class_name: '::ResourceRegistry::Mongoid::Feature'

      def item
        JSON.parse(super) if super.present?
      rescue JSON::ParserError
        super
      end

      def item=(value)
        write_attribute(:item, value.to_json)
      end
    end
  end
end
