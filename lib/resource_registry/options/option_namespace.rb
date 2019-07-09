module ResourceRegistry
  module Options
    class OptionNamespace < Dry::Struct 
      # attribute :parent_namespace?, Types::Symbol
      attribute :namespace?,        Types::Symbol
      attribute :options?,           Types::Array.of(Options::Option)
      attribute :namespaces?,       Types::Array.of(Options::OptionNamespace)
    end

  end
end
