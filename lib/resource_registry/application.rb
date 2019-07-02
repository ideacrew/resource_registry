# require 'dry-container'

module ResourceRegistry
  class Application < Repository


    register :default_store, :mongodb

    # ResourceRegistry::Application.config.test[:default].call
    register(:test, { one: 'val1', two: 'val2', default: -> { 6 * 7 } }) { |vals| vals }

    register :stores do
      register :mongodb do
        register :collection_name, 'resource_registry_registers'
      end
    end
  end

  namespace :serializers do
  end

  # Subscription Features
  # - Settings
  # - Business Rules

  
end
