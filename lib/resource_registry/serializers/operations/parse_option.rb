# frozen_string_literal: true

module ResourceRegistry
  module Serializers
    module Operations
      class ParseOption

        include Dry::Transaction::Operation

        def call(input)
          entity_hash = convert(input)

          Success(entity_hash)
        end

        private

        def convert(input, options = false)
          hash = {}

          if entity_types.include?(input[:key])
            hash[input[:key]] = input.fetch(:namespaces,[]).inject({}) do |data, ns|
              data[ns[:key]] = ns[:namespaces].collect{|sub_ns| convert(sub_ns) } if ns[:namespaces]
              data
            end
          else
            hash[:key] = input[:key]
            if options
              hash[:settings] = input[:settings] if input[:settings]
              hash[:namespaces] = input[:namespaces] if input[:namespaces]
            else
              input[:settings].each {|s| hash[s[:key]] = s[:default] } if input[:settings]
              input.fetch(:namespaces, []).each do |ns|
                hash[ns[:key]] = ns[:namespaces].collect{|sub_ns| convert(sub_ns, ns[:key] == :options) } if ns[:namespaces]
              end
            end
          end

          hash
        end

        def entity_types
          [:enterprise, :tenants, :sites, :features, :options]
        end
      end
    end
  end
end