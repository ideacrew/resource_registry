# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Operations
      class Boot
        send(:include, Dry::Monads[:result, :do])

        def call(config_file, container_constant_name)
          registry = yield create_registry(config_file)
          container = yield create_container(registry)
          yield persist_container(container, container_constant_name)

          Success(container)
        end

        private

        def create_registry(config_file)
          registry = Create.new.call(config_file)

          Success(registry)
        end

        def create_container(registry)
          container = ResourceRegistry::Stores::Container::Build.new(registry)

          Success(container)
        end

        def persist_container(container, const_name)
          container = ResourceRegistry::Stores::Container::Persist.new(registry)

          Success(container)
        end
      end
    end
  end
end
