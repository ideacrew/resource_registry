# frozen_string_literal: true
require 'dry/monads'

module ResourceRegistry
  module Operations
    module Namespaces
      class Build
        send(:include, Dry::Monads[:result, :do])

        NAVIGATION_TYPES = %w[feature_list nav]

        def call(feature)
          feature = yield validate(feature)
          values  = yield build(feature)

          Success(values)
        end

        private

        def validate(feature)
          return Failure("feature meta can't be empty") if feature.meta.to_h.empty?
          return Failure("feature namespace path can't be empty") if feature.namespace_path.to_h.empty?
          return Failure("namesapce content type should be #{NAVIGATION_TYPES}") unless NAVIGATION_TYPES.include?(feature.namespace_path.meta&.content_type&.to_s)
          Success(feature)
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

        # def construct(namespaces, feature)
        #   namespace_identifier = feature.namespace.map(&:to_s).join('.')
        #   if namespaces[namespace_identifier]
        #     namespaces[namespace_identifier][:features] << feature.key
        #   else
        #     namespaces[namespace_identifier] = {
        #       key: feature.namespace[-1],
        #       path: feature.namespace,
        #       features: [feature.key]
        #     }
        #   end
        #   Success(namespaces)
        # end
      end
    end
  end
end
