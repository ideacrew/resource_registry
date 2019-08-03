require 'yaml'

module ResourceRegistry
  module Serializers
    module Operations
      class ParseYaml
        
        include Dry::Transaction::Operation

        def call(input)
          Success(YAML.load(input))
        end
      end
    end
  end
end