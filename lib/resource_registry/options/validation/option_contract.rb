module ResourceRegistry
  module Options
    module Validation

      OptionContract = ResourceRegistry::Validation::ApplicationContract.build do

        params do
          required(:key).value(:symbol)
          
          optional(:settings).array(:hash) do
            required(:key).value(:symbol)
            required(:default).filled(:any)
            optional(:title).maybe(:string)
            optional(:description).maybe(:string)
            optional(:type).maybe(:string)
            optional(:value).maybe(:string)
          end

          optional(:namespaces).array(:hash)
        end

        rule(:namespaces).each do
          validation_errors = []
            result = ResourceRegistry::Options::Validation::OptionContract.call(value)

            if result && result.failure?
              validation_errors << result.errors.messages.reduce([]) do |list, message|
                list << [{ path: message.path }, { input: message.input.to_s }, { text: message.text.to_s }]
              end
            end          

          key.failure("validation failed: #{validation_errors.flatten}") if validation_errors.size > 0
        end
      end
    end
  end
end
