# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Create a Feature
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          feature_params = yield construct(params)
          feature_values = yield validate(feature_params)
          feature        = yield create(feature_values)

          Success(feature)
        end

        private

        def construct(params)
          params['namespace_path'] =  params['namespace'].is_a?(Hash) ? params.delete('namespace') : {path: params.delete('namespace')}
          Success(params)
        end

        def validate(params)
          ResourceRegistry::Validation::FeatureContract.new.call(params)
        end

        def create(feature_values)
          feature = ResourceRegistry::Feature.new(feature_values.to_h)
          Success(feature)
        end
      end
    end
  end
end
