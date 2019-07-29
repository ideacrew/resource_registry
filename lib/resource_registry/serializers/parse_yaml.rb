require 'yaml'

module ResourceRegistry
  module Serializers
    class Operattions
      class ParseYaml
        include Dry::Transaction::Operation

        def call(input)
          YAML.load(content)
        end

      end
    end
  end
end