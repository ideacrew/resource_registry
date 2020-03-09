# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Create a Feature
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          feature_values = yield validate(params)
          feature        = yield create(feature_values)

          Success(feature)
        end

        private

        def validate(params)
          result = ResourceRegistry::Validation::FeatureContract.new.call(params)

          if result.success?
            Success(result.to_h)
          else
            Failure(result)
          end
        end

        def create(feature_values)
          feature = ResourceRegistry::Feature.new(feature_values)

          Success(feature)
        end
      end
    end
  end
end