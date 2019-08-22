# frozen_string_literal: true

require 'dry/system/container'
require 'dry/transaction'
require 'dry/transaction/operation'
require 'dry/initializer'
require 'dry/validation'
require 'dry/monads/result'
require 'resource_registry/error'
require 'resource_registry/types'
require 'resource_registry/entities'
require 'resource_registry/validations'
require 'resource_registry/registries/operations/create_container'
require 'resource_registry/registries/transactions/load_container_dependencies'
require 'resource_registry/registries/transactions/registry_configuration'
require 'resource_registry/version'

module ResourceRegistry
  include Dry::Core::Constants

  class << self

    attr_reader :config, :resolver_config

    def configure
      result = initialize_container
      raise ResourceRegistry::Error::ContainerCreateError, result.errors if result.failure?

      assign_registry_constant(result.value!)
      load_container_dependencies

      result = Registries::Transactions::RegistryConfiguration.new.call(yield[:application])
      if result.failure?
        raise ResourceRegistry::Error::InitializationFileError, result.failure.messages
      end

      @config = result.value!
      @resolver_config = {resolver: yield[:resource_registry][:resolver]}
    end

    def initialize_container
      Registries::Operations::CreateContainer.new.call
    end

    def assign_registry_constant(container)
      ResourceRegistry.send(:remove_const, 'RegistryInject') if defined? RegistryInject
      ResourceRegistry.const_set(:RegistryInject, container.injector)

      Kernel.send(:remove_const, 'Registry') if defined? Registry
      Kernel.const_set("Registry", container)
    end

    def load_container_dependencies
      dependencies_path = Pathname.new(__dir__).join('system', 'dependencies')
      Registries::Transactions::LoadContainerDependencies.new.call(dependencies_path)
    end

    def create
      path = Pathname.new(__dir__).join('system', 'config', 'configuration_options.yml')
      Registries::Transactions::Create.new.call(path)
    end
  end
end

