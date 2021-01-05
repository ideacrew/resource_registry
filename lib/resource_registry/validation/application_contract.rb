# frozen_string_literal: true

Dry::Validation.load_extensions(:monads)

module ResourceRegistry
  module Validation
    # Configuration values and shared rules and macros for domain model validation contracts
    class ApplicationContract < Dry::Validation::Contract
      config.messages.default_locale = :en

      # config.messages.backend = :i18n
      # config.messages.default_locale - default I18n-compatible locale identifier
      # config.messages.backend - the localization backend to use. Supported values are: :yaml and :i18n
      # config.messages.load_paths - an array of files paths that are used to load messages
      # config.messages.top_namespace - the key in the locale files under which messages are defined, by default it's dry_validation
      # config.messages.namespace - custom messages namespace for a contract class. Use this to differentiate common messages

      # Process validation contracts in a standard manner
      # @param evaluator [Dry::Validation::Contract::Evaluator]
      def apply_contract_for(evaluator)
        return {} unless evaluator.key && evaluator.value

        rule_keys = evaluator.key.path.keys
        contract_klass = create_contract_klass(rule_keys)
        result = contract_klass.new.call(evaluator.value)

        (result && result.failure?) ? { text: "invalid #{rule_keys[0]}", error: result.errors.to_h } : {}
      end

      # Construct a fully namespaced constant for contract based on naming conventions
      # @param [Dry::Validation::Contract::RuleKeys] rule_keys
      def create_contract_klass(rule_keys)
        klass_parts = rule_keys[0].to_s.split('_')
        module_name = klass_parts.reduce([]) { |memo, word| memo << word.capitalize }.join
        klass_name  = module_name.chomp('s')

        full_klass_name = ["ResourceRegistry", module_name, "Validation", klass_name + "Contract"].join('::')
        ::Kernel.const_get(full_klass_name)
      end

      # @!macro ruleeach
      #   Validates a nested array of $0 params
      #   @!method rule(settings)
      rule(:settings) do
        if key? && value
          setting_results = value.inject([]) do |results, setting_hash|
            result = ResourceRegistry::Validation::SettingContract.new.call(setting_hash)

            if result.failure?
              # Use dry-validation metadata error form to pass error hash along with text to calling service
              key.failure(text: "invalid settings", error: result.errors.to_h) if result && result.failure?
            else
              results << result.to_h
            end
          end

          values.merge!(settings: setting_results)
        end
      end

      # @!macro [attach] rulemacro
      #   Validates a nested hash of $1 params
      #   @!method $0($1)
      #   @param [Symbol] $1 key
      #   @return [Dry::Monads::Result::Success] if nested $1 params pass validation
      #   @return [Dry::Monads::Result::Failure] if nested $1 params fail validation
      rule(:meta) do
        if key? && value
          result = ResourceRegistry::Validation::MetaContract.new.call(value)

          if result.failure?
            # Use dry-validation error form to pass error hash along with text to calling service
            # self.result.to_h.merge!({meta: result.to_h})
            key.failure(text: "invalid meta", error: result.errors.to_h)
          else
            values.merge!(meta: result.to_h)
          end
        end
      end
    end
  end
end
