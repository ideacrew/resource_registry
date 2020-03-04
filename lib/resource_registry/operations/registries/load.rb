# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Registries

      # Create a Feature
      class Load
        send(:include, Dry::Monads[:result, :do])

        def call(config_dir:, registry:)
          paths    = yield list_paths(config_dir)
          result   = yield load(paths, registry)

          Success(result)
        end

        private 

        def list_paths(config_dir)
          paths = ResourceRegistry::Stores::File::ListPath.new.call(config_dir)

          Success(paths)
        end

        def load(paths, registry)
          paths.each do |path|
            ResourceRegistry::Operations::Registry::Create.new(path: path, registry: registry)
          end

          Success(registry)
        end
      end
    end
  end
end