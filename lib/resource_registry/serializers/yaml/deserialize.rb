# frozen_string_literal: true

require 'yaml'
require 'erb'
module ResourceRegistry
  module Serializers
    module Yaml
      # Transform a YAML-formatted String into a Hash object
      class Deserialize
        send(:include, Dry::Monads[:result, :do])

        # @param [String] params YAML String to be transformed into a Hash
        # @return [Hash] parsed values wrapped in Dry::Monads::Result object
        def call(params)
          values = yield transform(params)
          Success(values)
        end

        private

        def transform(params)
          # result = JSON.parse(ERB.new(JSON::dump(YAML.load(params))).result)

          result = YAML.load(ERB.new(params).result)
          Success(result || {})
        rescue Psych::SyntaxError => e
          raise "YAML syntax error occurred while parsing #{params}. " \
                "Error: #{e.message}"
        end
      end
    end
  end
end
