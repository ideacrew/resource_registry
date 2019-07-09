require 'dry-struct'
require 'resource_registry/types'
require 'resource_registry/options/option'
require 'resource_registry/options/option_namespace'
require 'resource_registry/options/portal'
require 'resource_registry/options/feature'
require 'resource_registry/options/application'
require 'resource_registry/options/tenant'
require 'resource_registry/options/site'

module ResourceRegistry
  module Options

    def to_hash
      JSON.parse(self.to_json)
    end

  end
end