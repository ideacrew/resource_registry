require 'dry-container'
# require "dry-auto_inject"

module ResourceRegistry
  class Repository
    include Dry::Container::Mixin

    attr_reader :namespace_root

    def initialize(tenant_key = nil)

      # Top level namespace under which all items are stored
      @namespace_root ||= set_tenant(tenant_key)

      # @stores       = ResourceRegistry::Stores::Store.store_set
      # Use Consul here to access site configuration settings

      yield self if block_given?
      self
    end

    def self.build
      new
    end

    def self.namespace_join(namespace_list)
      if namespace_list.length > 1
        namespace_list.join('.')
      else
        namespace_list.to_s
      end
    end

    # Establish the namespace_root based on the tenant_key.
    # The tenant_key value is stored as a string (to enable dot
    # notation).  If tenant_key is nil, its value is stored as an
    # empty string.  
    def set_tenant(tenant_key)
      tenant_key_str = tenant_key.to_s
      register(:tenant_key) { tenant_key_str } 

      extend_namespace(tenant_key_str) if tenant_key != nil
      tenant_key_str
    end

    def tenant_key
      resolve(:tenant_key)
    end

    def extend_namespace(namespace)
      namespace = self.namespace_join(namespace) if namespace is_a? Array
      namespace_klass = build_namespace(namespace)
      import namespace_klass
    end

    # Build a Namespace object, creating macros that perform the following:
    # _all_keys: list of all keys in the namespace, including macros that start with and underscore ('_') character
    # _keys: list of all non-macro keys in the namespace
    # _pairs: list of key/value pairs in the namespace
    def build_namespace(namespace)
      Dry::Container::Namespace.new(namespace) do
        register('_all_keys') { ns_exp = /\A#{Regexp.quote(namespace)}./;   keys.reduce([]) { |list, key| list << key if ns_exp.match?(key, 0); list }}
        register('_keys')     { ns_exp = /\A#{Regexp.quote(namespace)}.[^_]/; keys.reduce([]) { |list, key| list << key if ns_exp.match?(key, 0); list }}
        register('_pairs')    { resolve("_keys").reduce([]) { |list, key| list <<  Hash("#{key}" => resolve("#{key.split('.').last}")) } }
      end
    end

    private

    def resolve_namespace(namespace)
      if @namespace_root != nil && @namespace_root != "" && (@namespace_root != namespace)
        namespace = [@namespace_root, namespace].join('.')
      end
      namespace
    end

    def build_cache(name)
      @data_store = ThreadSafe::Cache.new.tap do |ds|
        ds[name] = ThreadSafe::Array.new
      end
    end

  end
end
