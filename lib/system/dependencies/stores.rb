require 'resource_registry/stores'

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

  container.register :persist_file do
    ResourceRegistry::Stores::Operations::PersistFile.new
  end
  
  container.register :persist_container do
    ResourceRegistry::Stores::Operations::PersistContainer.new
  end  
end