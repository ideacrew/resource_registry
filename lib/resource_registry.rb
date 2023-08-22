# frozen_string_literal: true

require 'dry/validation'

require 'dry/monads'
require 'dry/monads/do'
require 'dry-struct'


require 'resource_registry/version'
require 'resource_registry/error'

require 'resource_registry/types'
require 'resource_registry/stores'
require 'resource_registry/serializers'
require 'resource_registry/validation/application_contract'
require 'resource_registry/railtie' if defined? Rails

require 'resource_registry/meta'
require 'resource_registry/setting'
require 'resource_registry/feature'
require 'resource_registry/feature_dsl'
require 'resource_registry/configuration'
require 'resource_registry/registry'

module ResourceRegistry
end
