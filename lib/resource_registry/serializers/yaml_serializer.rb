require 'yaml'

module ResourceRegistry
  module Serializers
    class YamlSerializer
      include ResourceRegistry::Service

      def call(**params)
        @content = params[:content]
        @action  = params[:action]

        send(@action)
      end

      def parse
        YAML.load(@content)
      end

      def generate
        @content.to_yaml
      end
    end
  end
end