require 'dry/validation'

module ResourceRegistry
  module Validation
    class ApplicationContract < Dry::Validation::Contract
      config.messages.default_locale = :en
      # config.messages.backend = :i18n

# config.messages.default_locale - default I18n-compatible locale identifier
# config.messages.backend - the localization backend to use. Supported values are: :yaml and :i18n
# config.messages.load_paths - an array of files paths that are used to load messages
# config.messages.top_namespace - the key in the locale files under which messages are defined, by default it’s dry_validation
# config.messages.namespace - custom messages namespace for a contract class. Use this to differentiate common messages

      # Define a macro for all subclasse that checks an email string format
      # Reference it in contract: rule(:email).validate(:email_format)
      register_macro(:email_format) do
        unless /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(value)
          key.failure('not a valid email format')
        end
      end

      StrictSymbolizingHash = Types::Hash.schema({}).strict.with_key_transform(&:to_sym)

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

      rule(:features).each do
        errors = validate_nested_contract(ResourceRegistry::Features::Validation::FeatureContract, value)
        key.failure("validation failed: #{errors.flatten}") unless errors.empty?
      end

      rule(:namespaces).each do
        errors = validate_nested_contract(ResourceRegistry::Options::Validation::OptionContract, value)
        key.failure("validation failed: #{errors.flatten}") unless errors.empty?
      end

      rule(:tenants).each do
        errors = validate_nested_contract(ResourceRegistry::Tenants::Validation::TenantContract, value)
        key.failure("validation failed: #{errors.flatten}") unless errors.empty?
      end

    end
  end
end