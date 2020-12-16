# frozen_string_literal: true
require 'dry/monads'

module ResourceRegistry
  module Operations
    module Namespaces
      # Create a Feature
      class Build
        send(:include, Dry::Monads[:result, :do])

        def call(namespaces = {}, feature)
          namespaces = yield construct(namespaces, feature)
          # values     = yield validate(params)
          # namespace  = yield build(values)
          
          Success(namespaces)
        end

        private

        def construct(namespaces, feature)
          namespace_identifier = feature.namespace.map(&:to_s).join('.')

          if namespaces[namespace_identifier]
            namespaces[namespace_identifier][:features] << feature.key
          else
            namespaces[namespace_identifier] = {
              key: feature.namespace[-1],
              path: feature.namespace,
              features: [feature.key]
            }
          end

          Success(namespaces)
        end
      end
    end
  end
end
