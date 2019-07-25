module ResourceRegistry
  module Entities
    class Options  < Dry::Struct
      include Enumerable

      transform_keys(&:to_sym)

      # attribute :parent_namespace?, Types::Symbol
      attribute :namespace?,   Types::Symbol
      attribute :key,          Types::Symbol

      # TODO: Make settings attribute dynamically typed
      attribute :settings?,   Types::Array.of(Setting)
      attribute :namespaces?, Types::Array.of(Options)

      def validate
      end

      def persist
      end

      def to_container(namespace = nil)
        container = namespace || Dry::Container::new
        container.namespace(key) do |namespace|
          load_container_for namespaces, namespace
          load_container_for settings, namespace
        end
        container
      end

      def to_yaml
      end

      def to_json
      end

      protected

      def new_dry_struct_member(name)
        name = name.to_sym
        unless respond_to?(name)
          define_singleton_method(name) { @table[name] }
          define_singleton_method("#{name}=") { |x| modifiable[name] = x }
        end
        name
      end

      # Recursively converts Hashes to Options (including Hashes inside Arrays)
      def __convert(h) #:nodoc:
        s = self.class.new

        h.each do |k, v|
          k = k.to_s if !k.respond_to?(:to_sym) && k.respond_to?(:to_s)
          s.new_ostruct_member(k)

          if v.is_a?(Hash)
            v = v["type"] == "hash" ? v["contents"] : __convert(v)
          elsif v.is_a?(Array)
            v = v.collect { |e| e.instance_of?(Hash) ? __convert(e) : e }
          end

          s.send("#{k}=".to_sym, v)
        end
        s
      end

      def descend_array(array) #:nodoc:
        array.map do |value|
          if value.instance_of? ResourceRegistry::Options
            value.to_hash
          elsif value.instance_of? Array
            descend_array(value)
          else
            value
          end
        end
      end


      def to_hash
        JSON.parse(self.to_json)
      end

    end
  end
end