# frozen_string_literal: true
module ResourceRegistry
  module ActiveRecord
    class Setting < ::ActiveRecord::Base
      self.table_name = "resource_registry_settings"

      belongs_to  :feature, class_name: 'ResourceRegistry::ActiveRecord::Feature'
      has_one     :meta, as: :editable, class_name: 'ResourceRegistry::ActiveRecord::Meta', dependent: :destroy

      accepts_nested_attributes_for :meta

      def meta=(attrs)
      	build_meta(attrs) if attrs.present?
      end

      def item=(val)
        super(val.to_yaml)
      end

      def item
        value = super
        return nil if value.nil?

        value = YAML.parse(value)
        value.respond_to?(:transform) ? value.transform : value
      rescue Psych::SyntaxError
        super
      end

      def to_h
        attributes.merge({
          'key'  => key.to_sym,
          'item' => item,
          'meta' => meta&.to_h
        })
      end
    end
  end
end
