module ResourceRegistry
  module Options
    class OptionNamespace < Dry::Struct 
      include DryStructSetters
      transform_keys(&:to_sym)

      # attribute :parent_namespace?, Types::Symbol
      attribute :key,               Types::Symbol
      attribute :options?,          Types::Array.of(Options::Option)
      attribute :namespaces?,       Types::Array.of(Options::OptionNamespace)
    end
  end
end
