# frozen_string_literal: true

Dry::Validation.load_extensions(:monads)

module ResourceRegistry
  module Validation
    class ApplicationContract < Dry::Validation::Contract
      config.messages.default_locale = :en
      # config.messages.backend = :i18n
      # config.messages.default_locale - default I18n-compatible locale identifier
      # config.messages.backend - the localization backend to use. Supported values are: :yaml and :i18n
      # config.messages.load_paths - an array of files paths that are used to load messages
      # config.messages.top_namespace - the key in the locale files under which messages are defined, by default it's dry_validation
      # config.messages.namespace - custom messages namespace for a contract class. Use this to differentiate common messages

      def create_contract_klass(rule_keys)
        klass_parts = rule_keys[0].to_s.split('_')
        module_name = klass_parts.reduce([]) { |memo, word| memo << word.capitalize }.join
        klass_name  = module_name.chomp('s')
        # binding.pry
        full_klass_name = ["ResourceRegistry", module_name, "Validation", klass_name + "Contract"].join('::')
        ::Kernel.const_get(full_klass_name)
      end

      def apply_contract_for(evaluator)
        return {} unless evaluator.key && evaluator.value

        rule_keys = evaluator.key.path.keys
        contract_klass = create_contract_klass(rule_keys)
        result = contract_klass.new.call(evaluator.value)

        (result && result.failure?) ? { text: "invalid #{rule_keys[0]}", error: result.errors.to_h } : {}
      end

      rule(:meta) do
        if key? && value
          result = ResourceRegistry::Validation::Metas::MetaContract.new.call(value)

          # Use dry-validation error form to pass error hash along with text to calling service
          key.failure(text: "invalid meta", error: result.errors.to_h) if result && result.failure?
        end
      end

      rule(:settings).each do
        next unless key? && value
        result = ResourceRegistry::Validation::Settings::Setting.new.call(value)

        # Use dry-validation error form to pass error hash along with text to calling service
        key.failure(text: "invalid setting", error: result.errors.to_h) if result && result.failure?
      end

      rule(:tenants).each do
        error_hash = apply_contract_for(self)
        key.failure(error_hash) unless error_hash.empty?

        # if key? && value
        #   result = ResourceRegistry::Tenants::Validation::TenantContract.new.call(value)

        #   # Use dry-validation metadata form to pass error hash along with text to calling service
        #   key.failure(text: "invalid tenant", error: result.errors.to_h) if result && result.failure?
        # end
      end

    end
  end
end
