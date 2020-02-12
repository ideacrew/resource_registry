# frozen_string_literal: true
puts "in resource_registry!!!"

require 'dry/system/container'
require 'dry/transaction'
require 'dry/transaction/operation'
require 'dry/initializer'
require 'dry/validation'
require 'dry/monads/result'
require 'dry/monads'
require 'dry/monads/do'


require 'resource_registry/version'
require 'resource_registry/error'
require 'resource_registry/types'

require 'resource_registry/validations'

puts "past validations require!!!"

# require 'resource_registry/stores'
# require 'resource_registry/serializers'

# require 'resource_registry/registries'
# require 'resource_registry/options'
# require 'resource_registry/metas'
# require 'resource_registry/features'
# require 'resource_registry/tenants'
require 'resource_registry/enterprises'

# require 'resource_registry/operations'


# require 'resource_registry/registries/operations/create_container'
# require 'resource_registry/registries/transactions/load_container_dependencies'

puts "past all requires!!!"

module ResourceRegistry
  include Dry::Core::Constants

  class << self

    # attr_reader :config, :resource_registry_config

    # attr_writer :configuration

    # def configuration
    #   @configuration ||= Configuration.new
    # end

    # def reset
    #   @configuration = Configuration.new
    # end

    # def configure
    #   yield configuration
    # end


    # Create container
    # Assign constant to container
    # Load local container dependencies
    #   Serializers
    #   Stores
    #   Registries
    #   Enterprises (entities?)

    # Load host application container dependencies/overrides

    def configure
binding.pry
      result = initialize_container
      raise ResourceRegistry::Error::ContainerCreateError, result.errors if result.failure?

      assign_registry_constant(result.value!)
      load_container_dependencies

      result = Registries::Transactions::RegistryConfiguration.new.call(yield[:application])
      if result.failure?
        raise ResourceRegistry::Error::InitializationFileError, result.failure.messages
      end

      @config = result.value!
      @resource_registry_config = yield[:resource_registry]
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
