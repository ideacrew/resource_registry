# frozen_string_literal: true
require 'yaml'

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
          Success(YAML.load(params))
        end

      end
    end
  end
end
