module ResourceRegistry
  module Options
    class OptionNamespace < Dry::Struct 
      # include DryStructSetters
      transform_keys(&:to_sym)

      # attribute :parent_namespace?, Types::Symbol
      attribute :key,               Types::Symbol
      attribute :options?,          Types::Array.of(Options::Option)
      attribute :namespaces?,       Types::Array.of(Options::OptionNamespace)

      def load!(ns)
        ns.namespace(key) do |namespace|
          load_collection namespaces, namespace
          load_collection options, namespace
        end
      end






    end
  end
end
