module ResourceRegistry
  module Options
    module Validation

      FeatureContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:key).value(Types::SymbolOrString)
          required(:is_required).value(Types::boolean).default(false)
          optional(:alt_key).maybe(Types::SymbolOrString)
          optional(:title).maybe(:string)
          optional(:description).maybe(:string)
          optional(:parent).maybe(Types::SymbolOrString)

          optional(:environments).array(:hash) do
            required(:key).value(Types::Environment).default(:production)
            required(:feature_enabled).value(Types::boolean).default(false)
            optional(:registry).value(type?: RegistyContract)
            optional(:options).maybe(type?: ResourceRegistry::Entities::Option)
          end

          optional(:features).array(:hash)
        end

        # Use dry-types hash schema transformation to enable recursion
        # on the :namespaces key
        Types::Hash.with_type_transform do |type, name|
          if name.to_s.eql?('features')
            type.constructor { |val| FeatureContract.call(val) }
          elsif name.to_s.eql?('options')
            type.constructor { |val| OptionContract.call(val) }
          else
            type
          end
        end


      end

    end
  end
end