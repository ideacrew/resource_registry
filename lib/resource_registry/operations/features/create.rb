# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Create a Feature
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          params  = yield construct(params)
          values  = yield validate(params)
          feature = yield create(values)

          Success(feature)
        end

        private

        def construct(params)
          if params[:namespace_path].blank?
            params['namespace_path'] = params['namespace'].is_a?(Hash) ? params.delete('namespace') : {path: params.delete('namespace')}
          end

          Success(params)
        end

        def validate(params)
          ResourceRegistry::Validation::FeatureContract.new.call(params)
        end

        def create(values)
          feature = ResourceRegistry::Feature.new(values.to_h)

          Success(feature)
        end
      end
    end
  end
end