# frozen_string_literal: true
require 'dry/monads'

module ResourceRegistry
  module Operations
    module Registries
      # Create a Feature
      class Load
        send(:include, Dry::Monads[:result, :do])

        def call(registry:)
          paths    = yield list_paths(load_path_for(registry))
          values   = yield load_features(paths, registry)
          entities = yield merge_namespaces(values[:namespace_list])
          registry = yield register_graph(entities, values[:registry])

          Success(registry)
        end

        private

        def list_paths(load_path)
          paths = ResourceRegistry::Stores::File::ListPath.new.call(load_path)
          Success(paths)
        end

        def load_features(paths, registry)
          namespaces_list = []

          paths.value!.each do |path|
            result = ResourceRegistry::Operations::Registries::Create.new.call(path: path, registry: registry)
            namespaces_list << result.success[:namespace_list] if result.success?
          end

          Success(registry: registry, namespace_list: namespaces_list.flatten)
        end

        def merge_namespaces(namespace_list)
          namespaces = namespace_list.reduce({}) do |namespaces, ns|
            if namespaces[ns[:key]]
              namespaces[ns[:key]][:feature_keys] += ns[:feature_keys]
            else
              namespaces[ns[:key]] = ns
            end
            namespaces
          end

          Success(namespaces.values)
        end

        def register_graph(entities, registry)
          graph = ResourceRegistry::Operations::Graphs::Create.new.call(entities, registry)

          if graph.success?
            registry.register_graph(graph.value!)
          else
            ResourceRegistry.logger.error(graph.failure)
          end

          Success(registry)
        end

        def load_path_for(registry)
          registry.resolve('configuration.load_path')
        end
      end
    end
  end
end
