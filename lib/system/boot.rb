# Initialize container with core system settings
module ResourceRegistry

  ResourceRegistry::Services::CreateRegistry.call(type: :private)

  require_relative "local/persistence"
  require_relative "local/inject"
  
  # CoreContainer.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'
end