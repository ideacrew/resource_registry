require 'yaml'

module ResourceRegistry
  module Serializers
    module Operations
      class SymbolizeKeys
        
        include Dry::Transaction::Operation

        def call(input)
          input.deep_symbolize_keys!
          return Success(input)
        end
      end
    end
  end
end