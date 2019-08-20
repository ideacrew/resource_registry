module ResourceRegistry
  module Serializers
    class OptionResolver < Dry::Container::Resolver

      def call(container, key)
        key   = key.to_s
        as_is = key.match(/^resource_registry/).present?
        as_is = key.scan(/^#{root_key(container)}/).any? unless as_is
        key   = [key_prefix(container), key].join('.') unless as_is

        super container, key
      end
      
      def key_prefix(container)
        return @key_prefix if defined? @key_prefix

        @key_prefix = [
          call(container, :'resource_registry.resolver.root'),
          call(container, :'resource_registry.resolver.tenant'),
          call(container, :'resource_registry.resolver.site'),
          call(container, :'resource_registry.resolver.env'),
          call(container, :'resource_registry.resolver.application')
        ].map(&:to_s).join('.')
      end

      def root_key(container)
        return @root if defined? @root
        @root = call(container, :'resource_registry.resolver.root').to_s
      end
    end
  end
end