require 'yaml'

module ResourceRegistry
  module Serializers
    class YamlGenerate
      include ResourceRegistry::Services::Service

      def call(**params)
        execute(params)
      end

      def execute(content)
        content.to_yaml
      end
    end
  end
end