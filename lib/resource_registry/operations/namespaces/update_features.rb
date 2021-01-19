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
            feature = registry[params[:key]]
            update_model_attributes(params, registry) if feature.meta&.content_type == :model_attributes
            ResourceRegistry::Operations::Features::Update.new.call(feature: feature_params.first, registry: registry)
          end

          Success(registry)
        end

        def update_model_attributes(params, registry)
          feature = registry[params[:key]]
          item = feature.item

          model_klass = item['class_name'].constantize

          record = if item['scope'].present?
            model_klass.send(item['scope']['name'], *item['scope']['arguments'])
          elsif item['where'].present?
            criteria = item['where']['arguments']
            model_klass.where(criteria)
          end

          if record
            record.assign_attributes(params[:settings].values.reduce({}, :merge))
            record.save(validate: false)
          end
        rescue NameError => e
          Failure("Exception #{e} occured while updating feature #{params[:key]} ")
        end
      end
    end
  end
end
