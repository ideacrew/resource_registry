module ResourceRegistry
  module Options
    class Feature < Dry::Struct # FEHB, SHOP, IVL, GA
      include DryStructSetters
      transform_keys(&:to_sym)

      attribute :key,                 Types::Symbol
      attribute :title?,              Types::Strict::String
      attribute :description?,        Types::Strict::String
      attribute :portal?,             Options::Portal
      attribute :namespaces?,         Types::Array.of(Options::OptionNamespace)
      attribute :options?,            Types::Array.of(Options::Option)

      def load!(ns)
        ns.namespace(key) do |namespace|
          load_collection namespaces, namespace
          load_collection options, namespace
        end
      end
    end
  end
end


