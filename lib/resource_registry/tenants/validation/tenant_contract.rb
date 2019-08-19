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

            optional(:environments).array(EnvironmentHash)
            # optional(:environments).array(:hash) do
            #   optional(:production).hash(EnvironmentHash)
            #   optional(:test).hash(EnvironmentHash)
            #   optional(:development).hash(EnvironmentHash)
            # end
          end
        end

        # rule(:key) do
        #   binding.pry
        # end

        # rule(:sites).each do
        #   binding.pry
        # end

        rule(:sites).each do
          validation_errors = []

          # binding.pry
          value[:environments].each do |environment|
            valid_environment_keys = [:production, :development, :test]

            if valid_environment_keys.include? environment[:key]
              # binding.pry
              if environment[:features]
                environment[:features].each do |feature|
                  result = ResourceRegistry::Features::Validation::FeatureContract.call(feature)
                  if result && result.failure?
                    validation_errors << result.errors.messages.reduce([]) do |list, message|
                      list << { :features => [{ path: message.path }, { input: message.input.to_s }, { text: message.text.to_s }] }
                    end
                  end
                end
              end

              if environment[:options]
                environment[:options].each do |option|
                  result = ResourceRegistry::Options::Validation::OptionContract.call(option)
                  if result && result.failure?
                    validation_errors << result.errors.messages.reduce([]) do |list, message|
                      list << { :options => [{ path: message.path }, { input: message.input.to_s }, { text: message.text.to_s }] }
                    end
                  end
                end
              end

            else
              validation_errors << { :environments => "invalid key: #{environment[:key]}" }
            end
          end

          key.failure("validation failed: #{validation_errors.flatten}") if validation_errors.size > 0
        end

          #   if value[:environments]

          #   if value[:environments]
          #     valid_environments = [:production, :development, :test]
          #     if (valid_environments.include? value[:environments])
          #       valid_environments.each do |env|
          #         # next if value[:environments].empty?
          #         binding.pry

          #         value[:environments].each do |hash_key, val|
          #           result = case hash_key
          #           when :options
          #             ResourceRegistry::Options::Validation::OptionContract.call(val)
          #           when :features
          #             ResourceRegistry::Features::Validation::FeatureContract.call(val)
          #           end

          #           if result && result.failure?
          #             validation_errors << result.errors.messages.reduce([]) do |list, message|
          #               list << { hash_key => [{ path: message.path }, { input: message.input.to_s }, { text: message.text.to_s }] }
          #             end
          #           end
          #         end
          #       end
          #     else
          #       validation_errors << { :environments => "invalid key: #{value[:environments]}" } unless value[:environments].empty?
          #     end
          #   end
          #   key.failure("validation failed: #{validation_errors.flatten}") if validation_errors.size > 0
          # end
          # end
      end
    end
  end
end
