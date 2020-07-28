# frozen_string_literal: true

require 'resource_registry/stores/operations/list_path'
require 'resource_registry/stores/operations/require_file'

module ResourceRegistry
  module Registries
    module Transactions
      class LoadContainerDependencies

        def call(dir)
          result = ResourceRegistry::Stores::Operations::ListPath.new.call(dir)
          return result unless result.success?
          paths = result.value!
          paths.each do |path|
            ResourceRegistry::Stores::Operations::RequireFile.new.call(path)
          end
        end
      end
    end
  end
end
