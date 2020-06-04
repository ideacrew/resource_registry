# frozen_string_literal: true
module ResourceRegistry
  module ActiveRecord
    class Setting < ::ActiveRecord::Base
      self.table_name = "resource_registry_settings"

      belongs_to  :feature, class_name: 'ResourceRegistry::ActiveRecord::Feature'
      has_one     :meta, as: :editable, class_name: 'ResourceRegistry::ActiveRecord::Meta', dependent: :destroy

      accepts_nested_attributes_for :meta


      def meta=(attrs)
      	build_meta(attrs)
      end
    end
  end
end
