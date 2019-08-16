module ResourceRegistry
  module Tenants
    module Validation

      PrimarySiteType = Types::Symbol.default(:primary)

      EnvironmentHash = Dry::Schema.Params do
        required(:key).value(:symbol)
        # required(:key).value(ResourceRegistry::Types::Environment)
        optional(:features).array(:hash)
        optional(:options).array(:hash)
      end

      TenantContract = ResourceRegistry::Validation::ApplicationContract.build do

        params do
          required(:key).value(:symbol)
          optional(:owner_organization_name).maybe(:string)
          optional(:owner_account_name).maybe(:string)
          optional(:options).array(:hash)

          optional(:subscriptions).array(:hash) do
            optional(:key).value(:symbol)
            optional(:id).maybe(:string)
            optional(:validator_id).maybe(:string)
            optional(:subscribed_on).maybe(ResourceRegistry::Types::CallableDate)
            optional(:unsubscribed_on).maybe(type?: Date)
            optional(:options).array(:hash)
          end

          optional(:sites).array(:hash) do
            required(:key).maybe(PrimarySiteType)
            optional(:url).maybe(:string)
            optional(:title).maybe(:string)
            optional(:description).maybe(:string)
            optional(:options).array(:hash)

            optional(:environments).array(:hash) do
              optional(:production).hash(EnvironmentHash)
              optional(:test).hash(EnvironmentHash)
              optional(:development).hash(EnvironmentHash)
            end
          end
        end


        rule(:sites).each do
          validation_errors = []

          if value[:environments]
            valid_environments = [:production, :development, :test]
binding.pry
            if (valid_environments.include? value[:environments]) || value[:environments].blank?
              valid_environments.each do |env|
                next if value[:environments].blank?

                value[:environments].each do |hash_key, val|
                  result = case hash_key
                  when :options
                    ResourceRegistry::Options::Validation::OptionContract.call(val)
                  when :features
                    ResourceRegistry::Features::Validation::FeatureContract.call(val)
                  end

                  if result && result.failure?
                    validation_errors << result.errors.messages.reduce([]) do |list, message|
                      list << { hash_key => [{ path: message.path }, { input: message.input.to_s }, { text: message.text.to_s }] }
                    end
                  end
                end
              end
            else
              validation_errors << { :environments => "invalid key: #{value[:environments]}" }
            end
          end
          key.failure("validation failed: #{validation_errors.flatten}") if validation_errors.size > 0
        end
      end
    end
  end
end
