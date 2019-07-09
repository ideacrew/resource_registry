module ResourceRegistry
  module Options
    class Feature < Dry::Struct # FEHB, SHOP, IVL, GA
      transform_keys(&:to_sym)

      attribute :key,                 Types::Symbol
      attribute :title?,              Types::Strict::String
      attribute :description?,        Types::Strict::String
      attribute :portal?,             Options::Portal

      attribute :namespaces?,         Types::Array.of(Options::OptionNamespace)
    end
  end
end