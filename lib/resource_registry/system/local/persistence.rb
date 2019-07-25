ResourceRegistry::CoreContainer.namespace "persistence" do |container|
  container.register "commands.create_options" do
    container["persistence"].command(:options)[:create]
  end

  container.register "commands.update_options" do
    container["persistence"].command(:options)[:update]
  end
end
