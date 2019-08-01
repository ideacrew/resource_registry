require 'dry/transaction'
require 'dry/transaction/operation'
require 'system/boot'
require 'resource_registry/error'
require 'resource_registry/types'
require 'resource_registry/entities'
require 'resource_registry/services'
require 'resource_registry/stores'
require 'resource_registry/validations'
require 'resource_registry/registries'
require 'resource_registry/serializers'
require 'resource_registry/version'

module ResourceRegistry
  include Dry::Core::Constants

  class << self

    def configure
      path = Pathname.new(__dir__).join("system", "config", "configuration_options.yml")
      registry_service = ResourceRegistry::Services::ConfigureRegistry.new
      registry_service.with_step_args(
        load_application_initializer: [preferences: yield]
      )
      .call(path)
    end

    def load_options(dir)
      Dir.glob(File.join(dir, "*")).each do |file_path|
        ResourceRegistry::Services::LoadRegistryOptions.new.call(file_path)
      end
    end

    alias_method :load_options!, :load_options
  end
end

