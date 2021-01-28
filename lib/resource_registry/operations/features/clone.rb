# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Create a Feature
      class Clone
        send(:include, Dry::Monads[:result, :do, :try])

        attr_reader :original_year, :new_calender_year

        def call(params:, registry:)
          options  = yield extract_options(params, registry)
          params   = yield construct_params(options)
          features = yield create(params)
          registry = yield persist(features, registry)

          Success(features)
        end

        private

        def extract_options(params, registry)
          feature_for_clone = registry[params[:target_feature]]
          related_features = feature_for_clone.feature.settings.collect do |setting|
            setting.item if setting.meta && setting.meta.content_type == :feature_list_panel
          end.compact.flatten

          features = []
          features << feature_for_clone.feature
          features += related_features.collect{|key| registry[key].feature}

          options = {
            features: features,
            calender_year: params[:settings][:calender_year]
          }

          Success(options)
        end

        def construct_params(options)
          @original_year = options[:features][0].key.to_s.scan(/\d{4}/)[0]
          @new_calender_year = options[:calender_year]
          features_params = options[:features].collect do |feature|
            serialize_hash(feature.to_h)
          end
          Success(features_params)
        end

        def create(feature_hashes)
          Try {
            feature_hashes.collect do |feature_hash|
              result = ResourceRegistry::Operations::Features::Create.new.call(feature_hash)
              return result if result.failure?
              result.value!
            end
          }.to_result
        end

        def persist(features, registry)
          features.each do |feature|
            ResourceRegistry::Stores.persist(feature, registry) if defined? Rails
            registry.register_feature(feature)
          end

          Success(registry)
        end

        def serialize_hash(attributes)
          attributes.reduce({}) do |values, (key, value)|
            values[key] = if value.is_a?(Hash)
              serialize_hash(value)
            elsif value.is_a?(Array)
              value.collect do |element|
                element.is_a?(Hash) ? serialize_hash(element) : serialize_text(element)
              end
            else
              serialize_text(value)
            end

            values
          end
        end

        def serialize_text(value)
          return value if value.blank?

          if value.is_a?(Symbol)
            value.to_s.gsub(original_year, new_calender_year).to_sym
          elsif value.is_a?(String)
            value.gsub(original_year, new_calender_year)
          else
            value
          end
        end
      end
    end
  end
end