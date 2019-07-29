# Initialize container with core system settings
module ResourceRegistry

  path = ResourceRegistry.system_path.join("config", "private_options.yml")
  result = ResourceRegistry::Services::CreateRegistry.new.call(path)
  ResourceRegistry.const_set('Registry', result.value!) if result.success?

  # require_relative "local/persistence"
  # require_relative "local/inject"
  
  # CoreContainer.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'
end