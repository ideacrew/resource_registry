# frozen_string_literal: true

module ResourceRegistry
  module Serializers
    module Namespaces
      # Transform feature collection into Namespace hash
      class Serialize
        send(:include, Dry::Monads[:result, :do, :try])

        # @param [Hash] params Hash to be transformed into YAML String
        # @return [String] parsed values wrapped in Dry::Monads::Result object
        def call(features:, namespace_types:)
          namespaces = yield build(features, namespace_types)
          namespace_dict = yield merge(namespaces)

          Success(namespace_dict.values)
        end

        private

        def build(features, namespace_types)
          Try do
            features.collect do |feature|
              namespace = ResourceRegistry::Operations::Namespaces::Build.new.call(feature, namespace_types)
              namespace.success if namespace.success?
            end.compact
          end.to_result
        end

        def merge(namespaces)
          Try do
            namespaces.reduce({}) do |data, ns|
              if data[ns[:key]]
                data[ns[:key]][:feature_keys] += ns[:feature_keys]
              else
                data[ns[:key]] = ns
              end
              data
            end
          end.to_result
        end
      end
    end
  end
end