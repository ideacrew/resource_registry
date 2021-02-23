# frozen_string_literal: true

require 'dry/system/container'

module ResourceRegistry
  # Container = Class.new(Dry::System::Container)
  # Kernel.const_set("Registry", ResourceRegistry::Container)
  # ResourceRegistry.const_set(:RegistryInject, Registry.injector)

  # # require_relative 'local/transactions'
  # # require_relative 'local/operations'
  # ResourceRegistry.initialize_container
  # ResourceRegistry.assign_registry_constant(container)

  # Dir[Pathname.new(__dir__).join("dependencies/*.rb").to_s].each(&method(:require))
end
