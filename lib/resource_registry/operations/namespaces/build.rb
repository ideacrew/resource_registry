# frozen_string_literal: true
require 'dry/monads'

module ResourceRegistry
  module Operations
    module Namespaces
      class Build
        send(:include, Dry::Monads[:result, :do])

        def call(feature, content_types = [])
          feature = yield validate(feature, content_types)
          values  = yield build(feature)

          Success(values)
        end

        private

        def validate(feature, content_types)
          errors = []
          errors << "feature meta can't be empty" if feature.meta.to_h.empty?
          errors << "feature namespace path can't be empty" if feature.namespace_path.to_h.empty?
          errors << "namesapce content type should be #{content_types}" if content_types.present? && content_types.exclude?(feature.namespace_path.meta&.content_type&.to_s)

          if errors.empty?
            Success(feature)
          else
            Failure(errors)
          end
        end

        def build(feature)
          namespace_path = feature.namespace_path
          
          Success({
            key: namespace_path.path.map(&:to_s).join('_'),
            path: namespace_path.path,
            feature_keys: [feature.key],
            meta: namespace_path.meta.to_h
          })
        end
      end
    end
  end
end
