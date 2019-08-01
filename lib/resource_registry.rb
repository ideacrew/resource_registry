require 'dry/transaction'
require 'dry/transaction/operation'
require 'dry/monads/result'
require 'system/boot'
require 'resource_registry/error'
require 'resource_registry/types'
require 'resource_registry/entities'
require 'resource_registry/services'
require 'resource_registry/stores'
require File.expand_path(File.join(File.dirname(__FILE__), 'resource_registry/validations'))
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
      files_to_load = Dir.glob(File.join(dir, "*")).to_a
      files_to_load.inject(Dry::Monads::Success(:ok)) do |result, file_path|
        result.bind do |_ignore|
          ResourceRegistry::Services::LoadRegistryOptions.new.call(file_path)
        end
      end
    end

    alias_method :load_options!, :load_options
  end
end

