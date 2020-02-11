# frozen_string_literal: true

require 'resource_registry/registries/transactions/registry_configuration'
require 'resource_registry/registries'


Registry.namespace :"resource_registry.registries" do

  register :validate do
    ResourceRegistry::Registries::Validation::RegistryContract.new
  end

  register :initialize_container do
    ResourceRegistry::Registries::Operations::CreateContainer.new
  end

  register :create do
    ResourceRegistry::Registries::Transactions::Create.new
  end

  register :configure do
    ResourceRegistry::Registries::Transactions::Configure.new
  end

  register :load_application_configuration do
    ResourceRegistry::Registries::Transactions::LoadApplicationConfiguration.new
  end

  register :load_application_dependencies do
    ResourceRegistry::Registries::Transactions::LoadApplicationDependencies.new
  end

  register :load_dependency do
    ResourceRegistry::Registries::Transactions::LoadDependency.new
  end

  register :load_registry_dependencies do
    ResourceRegistry::Registries::Transactions::LoadRegistryDependencies.new
  end
end