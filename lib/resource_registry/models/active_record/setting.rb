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

      def item_value
        return eval(item) if item.present? && item.scan(/\{|\[/).any?
        item
      rescue NameError
        item
      end

      def to_h
        attributes.merge({
          'key' => key.to_sym,
          'meta' => meta&.to_h,
          'item'=> item_value
        })
      end
    end
  end
end
