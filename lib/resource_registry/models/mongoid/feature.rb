# frozen_string_literal: true

module ResourceRegistry
  module Mongoid
    class Feature
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :key,         type: Symbol
      field :is_enabled,  type: Boolean
      field :item,        type: String

      embeds_one :meta, as: :metable, class_name: '::ResourceRegistry::Mongoid::Meta', cascade_callbacks: true
      embeds_one :namespace_path, class_name: '::ResourceRegistry::Mongoid::NamespacePath', cascade_callbacks: true
      embeds_many :settings, class_name: '::ResourceRegistry::Mongoid::Setting', cascade_callbacks: true

      def setting(key)
        settings.detect{|setting| setting.key.to_s == key.to_s}
      end

      def item
        JSON.parse(super) if super.present?
      end

      def item=(value)
        write_attribute(:item, value.to_json)
      end
    end
  end
end