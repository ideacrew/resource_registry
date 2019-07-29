require 'yaml'
require 'dry/transaction/operation'

module ResourceRegistry
  module Services
    module Transactions
      class Transaction
        include Dry::Transaction
        include Dry::Monads::Result::Mixin

      end
    end
  end
end
