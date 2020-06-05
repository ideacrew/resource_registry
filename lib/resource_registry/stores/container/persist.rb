# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Container

      # Instantiate a new Dry::Container object
      class Persist
        send(:include, Dry::Monads[:result, :do])

        # @param [ResourceRegistry::Entities::Registry] container the container instance to which the constant will be assigned
        # @param [String] constant_name the name to assign to the container and its associated dependency injector
        # @return [Dry::Container] A non-finalized Dry::Container with associated configuration values wrapped in Dry::Monads::Result
        def call(container, constant_name)
          container_constant  = yield set_container_constant(container, constant_name)
          container           = yield finalize(container_constant)

          Success(container)
        end

        private

        def set_container_constant(container, constant_name)
          container_inject = "#{constant_name}Inject"
          ResourceRegistry.send(:remove_const, container_inject) if defined? container_inject
          ResourceRegistry.const_set(container_inject, container.injector)

          Kernel.send(:remove_const, constant_name) if defined? constant_name
          Kernel.const_set(constant_name, container)

          Success(Kernel.const_get(constant_name))
        end
      
        def finalize(container)
          finalized_container = container.finalize!

          Success(finalized_container)
        end
      end
    end
  end
end
