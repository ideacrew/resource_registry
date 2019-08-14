module ResourceRegistry
  module Serializers
    module Operations
      class ParseOption
        
        include Dry::Transaction::Operation

        def call(input)
          entity_hash = convert(input)
          return Success(entity_hash)
        end

        private

        def convert(input)
          hash = {}
          
          if entity_types.include?(input[:key])
            hash[input[:key]] = input[:namespaces].inject({}) do |data, ns|
              data[ns[:key]] = ns[:namespaces].collect{|sub_ns| convert(sub_ns) } if ns[:namespaces]
              data
            end if input[:namespaces]
            # {convert(input[:namespaces]) if input[:namespaces] #.collect{|ns| convert(ns) } if input[:namespaces]
          else
            hash[:key] = input[:key]
            input[:settings].each {|s| hash[s[:key]] = s[:default] } if input[:settings]
            input[:namespaces].each do |ns|
              hash[ns[:key]] = ns[:namespaces].collect{|sub_ns| convert(sub_ns) } if ns[:namespaces]
            end if input[:namespaces]
          end
          
          hash
        end

        def entity_types
          [:enterprise, :tenants, :sites, :features]
        end
      end
    end
  end
end