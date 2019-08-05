module ResourceRegistry
  module Tenants
    module Validation

      TenantContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:key).value(Types::SymbolOrString)
          required(:environments).value(:symbol) do
          optional(:title).maybe(:string)
          optional(:description).maybe(:string)

          optional(:subscriptions).maybe(ResourceRegistry::Entities::Subscription)
          optional(:features).maybe(ResourceRegistry::Entities::Feature)
          optional(:sites).maybe(ResourceRegistry::Entities::Site)
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
