# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Namespaces
      class UpdateFeatures
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          feature_params = yield extract(params[:namespace])
          registry = yield update(feature_params, params[:registry])

          Success(registry)
        end

        private

        def extract(params)
          features = params[:features].values

          Success(features)
        end

        def update(feature_params, registry)
          feature_params.each do |params|
            ResourceRegistry::Operations::Features::Update.new.call(feature: params, registry: registry)
          end

          Success(registry)
        end
      end
    end
  end
end
