require "mongoid"
require "dry/inflector"

require 'resource_registry/repository'
require 'resource_registry/types'
require 'resource_registry/setting'

# require 'resource_registry/application'
require 'resource_registry/error'
require 'resource_registry/feature_check'
require 'resource_registry/version'

# require 'resource_registry/stores/store'

module ResourceRegistry
  include Dry::Core::Constants

  Inflector = Dry::Inflector.new

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
