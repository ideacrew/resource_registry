# frozen_string_literal: true

module ResourceRegistry
  module Serializers
    module Features
      # Transform a Hash into YAML-formatted String
      class Serialize
        send(:include, Dry::Monads[:result, :do])

        # @param [Hash] params Hash to be transformed into YAML String
        # @return [String] parsed values wrapped in Dry::Monads::Result object
        def call(params)
          features = yield transform(params)

          Success(features)
        end

        private

        def transform(params)
          return Success([]) if params.empty? || params['registry'].blank?

          features = params['registry'].reduce([]) do |features_list, namespace|
            next features_list unless namespace['features']
            path = namespace['namespace'] if namespace.key?('namespace')

            namespace_features = namespace['features'].reduce([]) do |ns_features_list, feature_hash|
              feature_hash['namespace'] ||= path
              ns_features_list << feature_hash
            end

            features_list += namespace_features
          end

          Success(features)
        rescue Exception => e
          raise "Error occurred while serializing #{params}. " \
                "Error: #{e.message}"
        end
      end
    end
  end
end
