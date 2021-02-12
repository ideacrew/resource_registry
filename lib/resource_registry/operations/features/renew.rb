# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Renew the given feature along with all associated features
      class Renew
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
          features = []
          features << registry[params[:target_feature]].feature

          related_features = features[0].settings.collect do |setting|
            get_features(setting.item) if setting.meta && setting.meta.content_type == :feature_list_panel
          end.compact.flatten

          features += related_features.collect{|feature| registry[feature.key].feature}

          options = {
            features: features,
            calender_year: params[:settings][:calender_year]
          }

          Success(options)
        end

        def construct_params(options)
          @original_year = options[:features][0].key.to_s.scan(/\d{4}/)[0]
          @new_calender_year = options[:calender_year]
          features_params = options[:features].collect{|feature| serialize_hash(feature.to_h)}

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

        def get_features(item)
          return item unless (item.is_a?(Hash) && item['operation'].present?)
          elements = item['operation'].split(/\./)
          elements[0].constantize.send(elements[1]).call(item['params'].symbolize_keys).success
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
          elsif value.is_a?(Range) && value.min.is_a?(Date)
            Range.new(new_date(value.begin), new_date(value.end))
          elsif value.is_a?(Date)
            value.next_year
          elsif value.is_a?(String) || value.to_s.match(/^\d+$/)
            value.to_s.gsub(original_year, new_calender_year)
          else
            value
          end
        end

        def new_date(ref_date)
          Date.new(new_calender_year.to_i, ref_date.month, ref_date.day)
        end
      end
    end
  end
end