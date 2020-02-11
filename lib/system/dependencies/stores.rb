# frozen_string_literal: true

require 'resource_registry/stores'

Registry.namespace :"resource_registry.stores.file" do |container|
  container.register :read do
    ResourceRegistry::Stores::File::Read.new
  end

  container.register :require do
    ResourceRegistry::Stores::File::Require.new
  end
end

Registry.namespace :"resource_registry.stores.container" do |container|
  container.register :create do
    ResourceRegistry::Stores::Container::Create.new
  end

  container.register :find do
    ResourceRegistry::Stores::Container::Find.new
  end

  container.register :write do
    ResourceRegistry::Stores::Container::Write.new
  end
end


Registry.namespace :"resource_registry.stores" do |container|

  container.register :load_file do
    ResourceRegistry::Stores::Operations::LoadFile.new
  end

  container.register :list_path do
    ResourceRegistry::Stores::Operations::ListPath.new
  end

  container.register :require_file do
    ResourceRegistry::Stores::Operations::RequireFile.new
  end

  container.register :persist_container do
    ResourceRegistry::Stores::Operations::PersistContainer.new
  end
end