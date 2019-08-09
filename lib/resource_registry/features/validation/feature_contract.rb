module ResourceRegistry
  module Features
    module Validation

      Falsey = Types::Bool.default(false)

      EnvironmentHash = Dry::Schema.Params do
        required(:is_enabled).value(Falsey)
        optional(:registry).value(:hash)
        optional(:options).value(:hash)
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
            optional(:production).hash(EnvironmentHash)
            optional(:test).hash(EnvironmentHash)
            optional(:development).hash(EnvironmentHash)
          end
        end

        rule(:environments).each do
          validation_errors = []

          value[:production].each do |hash_key, val|
            result = case hash_key
            when :registry
              ResourceRegistry::Registries::Validation::RegistryContract.call(val)
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

          key.failure("validation failed: #{validation_errors.flatten}") if validation_errors.size > 0
        end
      end
    end
  end
end