module ResourceRegistry
  module Options
    class OptionNamespace < Dry::Struct 
      attribute :parent_namespace?, Types::String
      attribute :namespace?,        Types::String
      attribute :options,           Types::Array.of(Options::Option)
    end
  end
end
