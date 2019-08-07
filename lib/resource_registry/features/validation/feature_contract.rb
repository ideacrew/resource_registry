module ResourceRegistry
  module Features
    module Validation

      Falsey = Types::Bool.default(false)

      EnvironmentHash = Dry::Schema.Params do
        required(:is_enabled).value(Falsey)
        optional(:registry).value(type?: ResourceRegistry::Registries::Validation::RegistryContract)
        optional(:options).value(type?: ResourceRegistry::Options::Validation::OptionContract)
        optional(:features).array(:hash)
      end

      FeatureContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:key).value(:symbol)
          required(:is_required).value(Falsey)
          optional(:alt_key).value(:symbol)
          optional(:title).maybe(:string)
          optional(:description).maybe(:string)
          optional(:parent).value(:symbol)

          optional(:environments).array(:hash) do
            optional(:production).value(ResourceRegistry::Types::Environments).array(EnvironmentHash)
            optional(:test).value(ResourceRegistry::Types::Environments).array(EnvironmentHash)
            optional(:development).value(ResourceRegistry::Types::Environments).array(EnvironmentHash)
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