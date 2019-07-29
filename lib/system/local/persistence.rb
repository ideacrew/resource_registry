ResourceRegistry::PrivateRegistry.namespace "persistence" do |container|

  container.register "peristence.serializer", "yaml_serializer"
  container.register "peristence.store", "file_store"
  container.register "peristence.container", "config"

  container.register "commands.create_options" do
    container["persistence"].command(:options)[:create]
  end

  container.register "commands.update_options" do
    container["persistence"].command(:options)[:update]
  end

  container.register "stores.file_store" do
    ResourceRegistry::Stores::FileStore.new
  end

  container.register "stores.mongo_store" do
    ResourceRegistry::Stores::MongoStore.new
  end
  
  container.register "serializers.yaml_serializer" do
    ResourceRegistry::Serializers::YamlSerializer.new
  end

  container.register "serializers.xml_serializer" do
    ResourceRegistry::Serializers::XmlSerializer.new
  end

  container.register "serializers.options_serializer" do
    ResourceRegistry::Serializers::OptionsSerializer.new
  end
end


# ResourceRegistry::PrivateRegistry.namespace "site" do |container|


#   container.register "tenents" do
#     ResourceRegistry::Stores::FileStore.new
#   end

#   container.register "applications" do
#     ResourceRegistry::Stores::MongoStore.new
#   end
  
#   container.register "serializers.yaml_serializer" do
#     ResourceRegistry::Serializers::YamlSerializer.new
#   end

#   container.register "serializers.xml_serializer" do
#     ResourceRegistry::Serializers::XmlSerializer.new
#   end

#   container.register "serializers.options_serializer" do
#     ResourceRegistry::Serializers::OptionsSerializer.new
#   end
# end
