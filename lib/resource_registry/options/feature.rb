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
        if options.present?
          ns.namespace(key) do |ns|
            options.each {|option| option.load!(ns) }
          end
        end
      end 
    end
  end
end


