require 'yaml'

module ResourceRegistry
  module Serializers
    class ParseYaml
      
      include Dry::Transaction::Operation

      def call(input)
        return Success(YAML.load(input))
      end
    end
  end
end