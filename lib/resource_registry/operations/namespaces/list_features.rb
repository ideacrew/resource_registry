# frozen_string_literal: true

# params: namespace
# returns array of feature dsl objects

module ResourceRegistry
  module Operations
    module Namespaces
      class ListFeatures
        send(:include, Dry::Monads[:result, :do, :try])

        def call(params)
          values   = yield validate(params)
          features = yield list_features(values)

          Success(features)
        end

        private

        def validate(params)
          return Failure("Namespace parameter missing.") unless params[:namespace]

          registry = params[:registry]
          registry = registry.constantize if registry.is_a?(String)
          return Failure("Unable to find namespace #{params[:namespace]} under #{params[:registry]}.") unless registry.namespaces.include?(params[:namespace])

          Success({
          	namespace: params[:namespace],
          	registry: registry
          })
        end

        def list_features(values)
          features = values[:registry].features_by_namespace(values[:namespace])

          Success(features)
        end
      end
    end
  end
end