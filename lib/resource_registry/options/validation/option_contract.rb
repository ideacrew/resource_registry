module ResourceRegistry
  module Options
    module Validation


      SettingSchema = Dry::Schema.Params do
        required(:key).filled(:symbol)
        required(:default).filled(:string)
        optional(:title).maybe(:string)
        optional(:description).maybe(:string)
        optional(:type).maybe(:string)
        optional(:value).maybe(:string)
      end


      OptionContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:key).value(Types::SymbolOrString)
          # optional(:settings).array(SettingContract)
          optional(:settings).array(SettingSchema)
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
