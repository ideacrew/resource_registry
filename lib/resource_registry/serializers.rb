require 'resource_registry/services/service'

require 'resource_registry/serializers/option_generate'
require 'resource_registry/serializers/xml_serializer'
require 'resource_registry/serializers/yaml_serializer'
require 'resource_registry/serializers/json_serializer'
require 'resource_registry/serializers/options_serializer'
require 'resource_registry/serializers/container_serializer'

require 'resource_registry/serializers/operations/parse_yaml'
require 'resource_registry/serializers/operations/generate_container'
require 'resource_registry/serializers/operations/create_option'
require 'resource_registry/serializers/transactions/generate_option'

module ResourceRegistry
  module Serializers
  end
end