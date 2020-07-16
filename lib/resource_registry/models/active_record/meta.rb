# frozen_string_literal: true
module ResourceRegistry
  module ActiveRecord
    class Meta < ::ActiveRecord::Base
      self.table_name = "resource_registry_meta"

      belongs_to :editable, polymorphic: true


      def to_h
      	attributes.merge({'content_type' => content_type&.to_sym})
      end
    end
  end
end

