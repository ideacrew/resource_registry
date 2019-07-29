module ResourceRegistry
  module Serializers
    module Transactions
      class TransformOption < Transaction

        try :validate, catch: ValidationError


      end
    end
  end
end
