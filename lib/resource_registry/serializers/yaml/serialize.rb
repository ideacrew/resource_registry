# frozen_string_literal: true
require 'yaml'

module ResourceRegistry
  module Serializers
    module Yaml

      # Transform a Hash into YAML-formatted String
      class Serialize
        send(:include, Dry::Monads[:result, :do])

        # @param [Hash] params Hash to be transformed into YAML String
        # @return [String] parsed values wrapped in Dry::Monads::Result object 
        def call(params)
          values = yield transform(params)
          Success(values)
        end

        private

        def transform(params)
          params_hash = params.to_h
          Success(params_hash.to_yaml)
        end

      end
    end
  end
end
