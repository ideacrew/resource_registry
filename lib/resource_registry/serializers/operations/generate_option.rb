require File.expand_path(File.join(File.dirname(__FILE__), "../..", "options/validation/option_contract"))

module ResourceRegistry
  module Serializers
    module Operations
      class GenerateOption
        include Dry::Transaction::Operation

        def call(input)
          schema = schema = ResourceRegistry::Options::Validation::OptionContract.new
          result = schema.call(input)
          
          if result.success?
            option = ResourceRegistry::Entities::Option.new(result.to_h)
            Success(option)
          else
            Failure(result.errors)
          end
        end
      end
    end
  end
end