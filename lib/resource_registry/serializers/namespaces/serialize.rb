# frozen_string_literal: true

module ResourceRegistry
  module Serializers
    module Namespaces
      # Transform a Hash into YAML-formatted String
      class Serialize
        send(:include, Dry::Monads[:result, :do, :try])

        # @param [Hash] params Hash to be transformed into YAML String
        # @return [String] parsed values wrapped in Dry::Monads::Result object
        def call(features:)
          namespaces = yield build(features)
          namespace_dict = yield merge(namespaces)

          Success(namespace_dict.values)
        end

        private

        def build(features)
          Try {
            features.collect do |feature|
              namespace = ResourceRegistry::Operations::Namespaces::Build.new.call(feature)
              namespace.success if namespace.success?
            end.compact
          }.to_result
        end

        def merge(namespaces)
          Try {
          	namespaces.reduce({}) do |namespaces, ns|
	            if namespaces[ns[:key]]
	              namespaces[ns[:key]][:feature_keys] += ns[:feature_keys]
	            else
	              namespaces[ns[:key]] = ns
	            end
	            namespaces
	          end
          }.to_result
        end
      end
    end
  end
end