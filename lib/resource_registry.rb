require "mongoid"
require "dry/inflector"
require 'dry-container'

require 'resource_registry/repository'
require 'resource_registry/configuration'
require 'resource_registry/options'

require 'resource_registry/error'
require 'resource_registry/feature_check'
require 'resource_registry/version'

# require 'resource_registry/stores/store'

module ResourceRegistry
  include Dry::Core::Constants

  Inflector = Dry::Inflector.new

  # Enable configuration in host Rails application using initializers:
  # config/initializers/resource_registry.rb
  #   ResourceRegistry.configure do |config|
  #     config.api_key = 'your_key_here'
  #   end
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end


  # Determines the namespace parent for the passed module or class constant
  # If the passed constant is top of the namespace, returns that constant
  def self.module_parent_for(child_module)
    list = child_module.to_s.split('::')
    if list.size > 1
      parents = list.slice(0, list.size - 1)

      const_get(parents.join('::'))
    else
      list.size == 1 ? child_module : nil
    end
  end

  def self.gem_file_path_for(namespace)
    namespace_str = Inflector.underscore(namespace)
    './lib/' + namespace_str
  end

  def self.file_kinds_for(file_pattern:, dir_base:)
    file_names = Dir.glob(file_pattern, base: dir_base)
    upper_bound = file_pattern.length

    file_names.reduce([]) do |list, file_name|
      list << file_name[0..upper_bound].to_sym
    end
  end

end
