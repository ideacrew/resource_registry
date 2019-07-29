require 'yaml'
require 'dry/transaction'

module ResourceRegistry
  module Services
    module Operations
      class Operation
        include Dry::Transaction::Operation
        include Dry::Monads::Result::Mixin

      end
    end
  end
end
