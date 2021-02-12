# frozen_string_literal: true
require 'dry/monads'

module ResourceRegistry
  module Operations
    module Registries
      # Create a Feature
      class Load
        send(:include, Dry::Monads[:result, :do, :try])

        def call(registry:)
          paths      = yield list_paths(registry)
          features   = yield load_features(paths, registry)
          namespaces = yield serialize_namespaces(features)
          registry   = yield register_graph(namespaces, registry)

          Success(registry)
        end

        private

        def list_paths(registry)
          load_path = registry.resolve('configuration.load_path')
          paths = ResourceRegistry::Stores::File::ListPath.new.call(load_path)

          Success(paths)
        end

        def load_features(paths, registry)
          Try {
            paths = paths.value!
            paths.reduce([]) do |features, path|
              result = ResourceRegistry::Operations::Registries::Create.new.call(path: path, registry: registry)
              features << result.success if result.success?
              features
            end.flatten
          }.to_result
        end

        def serialize_namespaces(features)
          ResourceRegistry::Serializers::Namespaces::Serialize.new.call(features: features, namespace_types: %w[feature_list nav])
        end

        def register_graph(namespaces, registry)
          graph = ResourceRegistry::Operations::Graphs::Create.new.call(namespaces, registry)

          if graph.success?
            registry.register_graph(graph.value!)
          else
            ResourceRegistry.logger.error(graph.failure)
          end

          Success(registry)
        end
      end
    end
  end
end
