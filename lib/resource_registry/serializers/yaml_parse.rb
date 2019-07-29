require 'yaml'

module ResourceRegistry
  module Serializers
    class YamlParse
      include ResourceRegistry::Services::Service

      def call(**params)
        execute(params)
      end

      def execute
        YAML.load(content)
      end
    end
  end
end