module ResourceRegistry
  module Stores
    class MongodbStore < Store
      include Mongoid::Document

      store_in collection: ResourceRegistry::Settings.config.stores.mongodb.collection_name

      field :tenant,                  type: Symbol
      field :configuration_set_name,  type: String
      field :configuration_set,       type: Hash

      validate_presence_of :tenant, :configuration_set

      def tenant=(new_tenant)
        write_attribute(:tenant, new_tenant.to_sym)
      end

      # Serialize the Configurable instance
      def configuration_set=(new_set)
        new_set.to_h
      end

      def persist!
        save
      end

    end
  end
end