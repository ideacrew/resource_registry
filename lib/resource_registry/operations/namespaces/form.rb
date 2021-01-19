# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Namespaces

      # Create a Namespace
      class Form
        send(:include, Dry::Monads[:result, :do, :try])

        def call(namespace:, registry:)
          features  = yield find_features(namespace, registry)
          params    = yield construct_params(namespace, features)
          values    = yield validate(params)
          namespace = yield create(values)

          Success(namespace)
        end

        private

        def find_features(namespace, registry)
          feature_keys = registry[:feature_graph].vertices.detect{|v| v.path == namespace}.feature_keys
          features = feature_keys.collect{|feature_key| find_feature(feature_key, registry)}

          Success(features)
        end

        def construct_params(namespace, features)
          params = {
            key: namespace.last,
            path: namespace,
            feature_keys: features.collect{|feature| feature[:key]},
            features: features
          }

          Success(params)
        end

        def validate(params)
          ResourceRegistry::Validation::NamespaceContract.new.call(params)
        end

        def create(values)
          namespace = ResourceRegistry::Namespace.new(values.to_h)

          Success(namespace)
        end

        def find_feature(feature_key, registry)
          feature = ResourceRegistry::Stores.find(feature_key) if defined? Rails
          feature&.success&.attributes || registry[feature_key].feature
        end
      end
    end
  end
end
