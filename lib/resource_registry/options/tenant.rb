module ResourceRegistry
  module Options
    class Tenant < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,             Types::Symbol
      attribute :title?,          Types::Strict::String
      attribute :description?,    Types::Strict::String
      # attribute :application_subscription_keys, Types::Array

      def to_container
        container = Dry::Container::new
        container.namespace(key) do |ns|
          ns.register(:key, key)
          ns.register(:title, title)
        end
        container
      end
    end
  end
end