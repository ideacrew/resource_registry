module ResourceRegistry
  module Features
    module Validation

      Falsey = Types::Bool.default(false)

      FeatureContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:key).value(:symbol)
          required(:is_required).value(Falsey)
          optional(:alt_key).value(:symbol)
          optional(:title).maybe(:string)
          optional(:description).maybe(:string)
          optional(:parent).value(:symbol)

          optional(:environments).array(:hash) do
            required(:key).value(ResourceRegistry::Types::Environments)
            required(:is_enabled).value(Falsey)
            optional(:registry).value(type?: ResourceRegistry::Registries::Validation::RegistryContract)
            optional(:options).value(type?: ResourceRegistry::Options::Validation::OptionContract)
            optional(:features).array(:hash)
          end
        end

        # Use dry-types hash schema transformation to enable recursion
        # on the :features key
        Types::Hash.with_type_transform do |type, name|
          if name.to_s.eql?('features')
            type.constructor { |val| FeatureContract.call(val) }
          else
            type
          end
        end

      end

    end
  end
end