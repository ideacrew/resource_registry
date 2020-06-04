# frozen_string_literal: true
module ResourceRegistry
  module ActiveRecord
    class Meta < ::ActiveRecord::Base
      self.table_name = "resource_registry_meta"

      belongs_to :editable, polymorphic: true
    end
  end
end

