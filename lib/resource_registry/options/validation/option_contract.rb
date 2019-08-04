module ResourceRegistry
  module Options
    module Validation

      OptionContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:key).value(Types::SymbolOrString)
          optional(:settings).array(:hash) do
            required(:key).filled(:symbol)
            required(:default).filled(:str?)
            optional(:title).maybe(:str?)
            optional(:description).maybe(:str?)
            optional(:type).maybe(:str?)
            optional(:value).maybe(:str?)
          end

          optional(:namespaces).array(:hash)
        end

        # Use dry-types hash schema transformation to enable recursion
        # on the :namespaces key
        Types::Hash.with_type_transform do |type, name|
          if name.to_s.eql?('namespaces')
            type.constructor { |val| OptionContract.call(val) }
          else
            type
          end
        end
      end
    end
  end
end
