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
          features = params['registry'].reduce([]) do |features_list, namespace|
            path = namespace['namespace']

            namespace_features = namespace['features'].reduce([]) do |ns_features_list, feature_hash|
              feature_hash['namespace'] ||= path
              feature = ResourceRegistry::Operations::Features::Create.new.call(feature_hash)
              if feature.success?
                ns_features_list << feature.value!
              else
                raise "Failed to create feature with #{feature.failure.errors.inspect}"
              end
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
