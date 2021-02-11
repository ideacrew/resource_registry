# frozen_string_literal: true

# params: namespace
# returns array of feature dsl objects

module ResourceRegistry
  module Operations
    module Namespaces
      class ListFeatures
        send(:include, Dry::Monads[:result, :do, :try])

        def call(params)
          values       = yield validate(params)
          feature_keys = yield list_features(values)
          features     = yield find_features(feature_keys, values)

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
            registry: registry,
            order: params[:order]
          })
        end

        def list_features(values)
          feature_keys = values[:registry].features_by_namespace(values[:namespace])

          Success(feature_keys)
        end

        def find_features(feature_keys, values)
          feature_model = ResourceRegistry::Stores.feature_model
          features = feature_keys.collect{|key| feature_model.present? ? feature_model.where(key: key).first : values[:registry][key].feature }.compact

          if values[:order]
            features_for_sort = features.select{|f| f.settings.any?{|s| s.key == values[:order].to_sym && s.item}}
            features = features_for_sort.sort_by{|f| sort_by_value(f, values[:order])}.reverse + (features - features_for_sort)
          end

          Success(features)
        end

        def sort_by_value(feature, setting_key)
          setting = feature.settings.detect{|s| s.key == setting_key.to_sym}
          setting.item.to_i
        end
      end
    end
  end
end