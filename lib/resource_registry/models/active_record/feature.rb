# frozen_string_literal: true
module ResourceRegistry
  module ActiveRecord
    class Feature < ::ActiveRecord::Base
      self.table_name = "resource_registry_features"

      has_one     :meta, as: :editable, class_name: '::ResourceRegistry::ActiveRecord::Meta', dependent: :destroy
      has_many    :settings, class_name: '::ResourceRegistry::ActiveRecord::Setting', dependent: :destroy

	  validates :key, uniqueness: true
      accepts_nested_attributes_for :meta, :settings

      def meta=(attrs)
      	build_meta(attrs)
      end

      def settings=(attrs)
        attrs.each do |setting_hash|
      	  settings.build(setting_hash)
        end
      end

      def setting(key)
      	settings.detect{|setting| setting.key.to_s == key.to_s}
      end
    end
  end
end