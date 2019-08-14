require 'dry-struct' unless defined?(Dry::Struct)
require 'dry-initializer'
require 'resource_registry/types'
require 'resource_registry/entities/option'
require 'resource_registry/entities/feature'
require 'resource_registry/entities/tenant'
require 'resource_registry/entities/registry'
require 'resource_registry/entities/enterprise'
require 'resource_registry/entities/qualifying_life_event'

module ResourceRegistry
  module Entities

    FeatureConstructor  = Types.Constructor('Feature')  { |val| Feature.new(val) rescue nil }
    OptionConstructor   = Types.Constructor('Option')   { |val| Option.new(val) rescue nil }
    RegistryConstructor = Types.Constructor('Registry') { |val| Registry.new(val) rescue nil }

  end
end