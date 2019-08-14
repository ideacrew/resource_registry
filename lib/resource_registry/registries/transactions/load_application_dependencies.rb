module ResourceRegistry
  module Registries
    module Transactions
      class LoadApplicationDependencies

        include Dry::Transaction(container: ::Registry)

        step :list_path, with: 'resource_registry.stores.list_path'
        step :load_dependencies

        private

        def list_path(input)
          path = Registry.config.root.join('system', 'config')
          super path
        end

        def load_dependencies(paths)
          paths.each do |path|
            ResourceRegistry::Registries::Transactions::LoadDependency.new.call(path)
          end
          return Success(paths)
        end
      end
    end
  end
end

