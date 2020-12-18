# frozen_string_literal: true

module ResourceRegistry
  module Mongoid
    class Feature
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :key,         type: Symbol
      field :is_enabled,  type: Boolean
      field :item,        type: String

      embeds_one  :namespace_path, class_name: '::ResourceRegistry::Mongoid::NamespacePath'
      embeds_one  :meta, class_name: '::ResourceRegistry::Mongoid::Meta'
      embeds_many :settings, class_name: '::ResourceRegistry::Mongoid::Setting'

      def setting(key)
        settings.detect{|setting| setting.key.to_s == key.to_s}
      end
    end
  end
end