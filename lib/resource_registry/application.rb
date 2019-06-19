require 'dry-configurable'

module ResourceRegistry
  class Application
    extend Dry::Configurable

    setting :default_store, :mongodb

    setting :stores do
      setting :mongodb do
        setting :collection_name, 'resource_registry_settings'
        setting :collection_name_meta do
          setting :type, :string
          setting :default, 'resource_registry_settings'
        end

      end
    end

    setting :serializers do
    end


  end
end
