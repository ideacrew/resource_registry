module ResourceRegistry
  module Options
    class Feature < Dry::Struct # FEHB, SHOP, IVL, GA
      transform_keys(&:to_sym)

      attribute :key,                 Types::Symbol
      attribute :title?,              Types::Strict::String
      attribute :description?,        Types::Strict::String
      attribute :portal?,             Options::Portal
      attribute :namespaces?,         Types::Array.of(Options::OptionNamespace)

      attribute :namespaces do
        attribute :name?,    Types::String
        attribute :options,  Types::Array.of(Options::Option)
      end

      def to_container
        Dry::Container::Namespace.new(key) do |ns|
          namespaces.options.each do |option|
            ns.register(option.key, option.default)
          end
        end
      end
    end
  end
end
