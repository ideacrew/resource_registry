Application::Container.namespace "persistence" do |container|
  container.register "commands.create_post" do
    container["persistence.rom"].command(:posts)[:create]
  end

  container.register "commands.create_user" do
    container["persistence.rom"].command(:users)[:create]
  end

  container.register "commands.create_person" do
    container["persistence.rom"].command(:people)[:create]
  end

  container.register "commands.create_category" do
    container["persistence.rom"].command(:categories)[:create]
  end

  container.register "commands.create_curated_post" do
    container["persistence.rom"].command(:curated_posts)[:create]
  end

  container.register "commands.create_categorisations" do
    container["persistence.rom"].command(:categorisations)[:create]
  end

  container.register "commands.create_project" do
    container["persistence.rom"].command(:projects)[:create]
  end
end
