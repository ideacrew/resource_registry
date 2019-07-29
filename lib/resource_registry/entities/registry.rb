module ResourceRegistry
  module Entities
    class Registry < Dry::Struct

      # Configuration values
      attribute :config do
        attribute :name,              Types::Strict::String
        attribute :root,              Types::Strict::String
        attribute :env,               Types::Strict::String

        attribute :default_namespace, Types::NilOrString #| Types::Undefined
        attribute :system_dir,        Types::NilOrString #| Types::Undefined
        attribute :load_path,         Types::NilOrString #| Types::Undefined

        # Dir, plus optional custom auto_register block
        attribute :auto_register,     Types::Array.of(Types::NilOrString) #| Types::Undefined
      end

      attribute :timestamp,           Types::DateTime.default { DateTime.now }

      # Persistence values
      attribute :persistence do
        attribute :store,       Types::Stores
        attribute :serializer,  Types::Serializers
        attribute :container,   Types::Strict::String
      end

      # Override or additional attributes
      attribute :options,     ResourceRegistry::Entities::Option

    end
  end
end
