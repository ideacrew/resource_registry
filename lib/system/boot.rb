# Initialize container with core system settings
module ResourceRegistry

  ResourceRegistry.const_set('Registry', Dry::Container.new)

  require_relative 'local/transactions'
  require_relative 'local/operations'

  # path = Pathname.pwd.join('lib', 'system', 'config', 'private_options.yml')
  # path = ResourceRegistry.system_path.join("config", "private_options.yml")

  # result = ResourceRegistry::Services::CreateRegistry.new.call(path)
  # ResourceRegistry.const_set('Registry', result.value!) if result.success?

  # require_relative "local/persistence"
  # require_relative "local/inject"
  
  # CoreContainer.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'
end