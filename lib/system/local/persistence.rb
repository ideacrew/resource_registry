ResourceRegistry::CoreContainer.namespace "persistence" do |container|
  container.register "commands.create_options" do
    container["persistence"].command(:options)[:create]
  end

  container.register "commands.update_options" do
    container["persistence"].command(:options)[:update]
  end

  container.register "stores.file_store" do
    ResourceRegistry::Stores::FileStore.new
  end
  
  container.register "serializers.yaml_serializer" do
    ResourceRegistry::Stores::FileStore.new
  end

  container.register "serializers.options_serializer" do
    ResourceRegistry::Stores::FileStore.new
  end
end
