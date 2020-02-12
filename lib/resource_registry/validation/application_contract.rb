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

      def validate_nested_contract(contract_constant, params)
        result = contract_constant.call(params)
        unpack_result(result)
      end

      def parse_message_path(path = [])
        if path.length == 1
          path.first.to_sym
        else
          path.reduce([]) { |list, val| list << val.to_s }.join('.').to_sym
        end
      end

      def unpack_result(result)
        if result && result.failure?
          message_list = result.errors.messages.reduce([]) do |list, message|
            message_key = parse_message_path(message.path)
            list << { message_key => [{path: message.path.to_s}, {input: message.input.to_s }, { text: message.text.to_s }] }
          end
        end
        message_list ||= []
      end

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

      rule(:ui_metadatas) do
        error_hash = apply_contract_for(self)
        key.failure(error_hash) if error_hash.size > 0
      end

      rule(:features).each do
        error_hash = apply_contract_for(self)
        key.failure(error_hash) if error_hash.size > 0

        # if key? && value
        #   result = ResourceRegistry::Features::Validation::FeatureContract.new.call(value)

        #   # Use dry-validation metadata form to pass error hash along with text to calling service
        #   key.failure(text: "invalid feature", error: result.errors.to_h) if result && result.failure?
        # end
      end

      rule(:tenants).each do
        error_hash = apply_contract_for(self)
        key.failure(error_hash) if error_hash.size > 0

        # if key? && value
        #   result = ResourceRegistry::Tenants::Validation::TenantContract.new.call(value)

        #   # Use dry-validation metadata form to pass error hash along with text to calling service
        #   key.failure(text: "invalid tenant", error: result.errors.to_h) if result && result.failure?
        # end
      end

      # rule(:features).each do
      #   errors = validate_nested_contract(ResourceRegistry::Features::Validation::FeatureContract, value)
      #   key.failure("validation failed: #{errors.flatten}") unless errors.empty?
      # end

      rule(:options).each do
        error_hash = apply_contract_for(self)
        key.failure(error_hash) if error_hash.size > 0
        # errors = validate_nested_contract(ResourceRegistry::Options::Validation::OptionContract, value)
        # key.failure("validation failed: #{errors.flatten}") unless errors.empty?
      end

      rule(:namespaces).each do
        # error_hash = apply_contract_for(self)
        # key.failure(error_hash) if error_hash.size > 0
        errors = validate_nested_contract(ResourceRegistry::Options::Validation::OptionContract, value)
        key.failure("validation failed: #{errors.flatten}") unless errors.empty?
      end

    end
  end
end
