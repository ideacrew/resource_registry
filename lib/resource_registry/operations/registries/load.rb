# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Registries

      # Create a Feature
      class Load
        send(:include, Dry::Monads[:result, :do])

        def call(registry:)
          paths    = yield list_paths(registry.load_path)
          result   = yield load(paths, registry)

          Success(result)
        end

        private

        def list_paths(load_path)
          paths = ResourceRegistry::Stores::File::ListPath.new.call(load_path)

          Success(paths)
        end

        def load(paths, registry)
          paths.value!.each do |path|
            ResourceRegistry::Operations::Registries::Create.new.call(path: path, registry: registry)
          end

          Success(registry)
        end
      end
    end
  end
end