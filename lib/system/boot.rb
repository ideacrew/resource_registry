require 'dry/system/container'

module ResourceRegistry
  
  Container = Class.new(Dry::System::Container)

  Kernel.const_set("Registry", ResourceRegistry::Container)
  ResourceRegistry.const_set(:RegistryInject, Registry.injector)

  require_relative 'local/transactions'
  require_relative 'local/operations'
end