# require "mongoid"
# require 'resource_registry/configuration'
# require 'resource_registry/feature_check'

## Deprecated
# require 'dry-container'
# require 'resource_registry/repository'
## 
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
require 'resource_registry/compactor'
require 'resource_registry/serializers'
require 'resource_registry/version'

module ResourceRegistry
  include Dry::Core::Constants

  # CONFIG_PATH = '/config/initializers/resource_registry.rb'

  # INFLECTOR = Dry::Inflector.new

  # # Initialize the Repository that contains the system configuration settings
  # Services::CreateOptionsRepository.call

  class << self

    def configure

      path = system_path.join("config", "public_options.yml")

      registry_service = ResourceRegistry::Services::CreateRegistry.new
      result = registry_service.with_step_args(
        create_registry: [preferences: yield],
        create_resource_registry: [preferences: yield]
      )
      .call(path)

      ResourceRegistry.const_set('Registry', result.value!) if result.success?

      # ResourceRegistry::Services::CreateRegistry.call(preferences: yield)
    end

    def root
      File.dirname __dir__
    end

    def system_path
      Pathname.new(__dir__).join('system')
    end

    def services_path
      Pathname.new(__dir__).join('resource_registry', 'services')
    end
  end


  # class << self

  #   def setup
  #     yield self unless @_ran_once
  #     @_ran_once = true
  #   end

  #   def load_options
  #     # repository = ResourceRegistry::Services::CreateOptiosRepository.call
  #     # ResourceRegistry::Services::FileLoad.call(repository: option_repository)
  #     # option_repository
  #   end
    
  #   def load_feature_select
  #     feature_repository = ResourceRegistry::Services::CreateFeatureSelectRepository

  #     ResourceRegistry::Services::FileLoad.call(repository: feature_repository)
  #     feature_repository
  #   end

  #   def reload!
  #     Object.const_get(ResourceRegistry.const_name).reload!
  #   end

  #   # Determines the namespace parent for the passed module or class constant
  #   # If the passed constant is top of the namespace, returns that constant
  #   def module_parent_for(child_module)
  #     list = child_module.to_s.split('::')
  #     if list.size > 1
  #       parents = list.slice(0, list.size - 1)

  #       const_get(parents.join('::'))
  #     else
  #       list.size == 1 ? child_module : nil
  #     end
  #   end

    # def self.file_kinds_for(file_pattern:, dir_base:)
    #   list = []
    #   Dir.glob(file_pattern, base: dir_base) do |file_name|
    #     upper_bound = file_name.length - file_pattern.length
    #     list << file_name[0..upper_bound].to_sym
    #   end
    #   list
    # end

    # def self.gem_file_path_for(namespace)
    #   namespace_str = INFLECTOR.underscore(namespace)
    #   './lib/' + namespace_str
    # end

  #   def container
  #     @@container
  #   end

  #   def root
  #     File.dirname __dir__
  #   end

  #   def services_path
  #     root + "/lib/resource_registry/services/"
  #   end

  #   def engines
  #     [Rails] + Rails::Engine.subclasses.select do |engine|
  #       File.exists?(engine.root.to_s + CONFIG_PATH)
  #     end
  #   end
  # end

  # private

  # @@container = Dry::Container.new
  # Config = Dry::AutoInject(@@container)
  # Dir.glob(ResourceRegistry.services_path + '*', &method(:require))
end

