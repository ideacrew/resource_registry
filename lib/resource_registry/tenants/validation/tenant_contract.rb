module ResourceRegistry
  module Tenants
    module Validation

      PrimarySiteType = Types::Symbol.default(:primary)

      TenantContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:key).value(:symbol)
          optional(:owner_organization_name).maybe(:string)
          optional(:owner_account_name).maybe(:string)

          optional(:subscriptions).array(:hash) do
            optional(:key).value(:symbol)
            optional(:id).maybe(:string)
            optional(:validator_id).maybe(:string)

            optional(:subscribed_on).maybe(ResourceRegistry::Types::CallableDate)
            optional(:unsubscribed_on).maybe(type?: Date)
          end

          optional(:sites).array(:hash) do
            required(:key).value(PrimarySiteType)
            optional(:url).maybe(:string)
            optional(:title).maybe(:string)
            optional(:description).maybe(:string)

            optional(:features).array(:hash)
          end
        end

        rule(:sites).each do
          validation_errors = []

          if value[:features]
            value[:features].each do |value|
              result = ResourceRegistry::Features::Validation::FeatureContract.call(value)

              if result && result.failure?
                validation_errors << result.errors.messages.reduce([]) do |list, message|
                  list << [{ path: message.path }, { input: message.input.to_s }, { text: message.text.to_s }]
                end
              end          
            end
          end

          key.failure("validation failed: #{validation_errors.flatten}") if validation_errors.size > 0
        end
      end


    end
  end
end
