require 'yaml'

module ResourceRegistry
  module Serializers
    class YamlSerializer
      include ResourceRegistry::Services::Service
      include ResourceRegistry::PrivateInject["options_validate", "options_persist"]

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