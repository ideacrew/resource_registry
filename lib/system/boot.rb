# Initialize container with core system settings
module ResourceRegistry

  path = Pathname.new(__dir__).join('config', 'private_options.yml')
  params = YAML.load_file(path)

  registry_contract = ResourceRegistry::Registries::Validation::RegistryContract.new
  result = registry_contract.call(params)

  if result.success?
    PrivateRegistry = ResourceRegistry::Registries::Registry.call(result)
    require_relative "local/inject"
  else
    raise Error::InvalidContractParams, "PrivateRegistry error(s): #{result.errors(full: true).to_h}"
  end
  
  # require_relative "local/persistence"

  # PrivateRegistry.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'

  # path = root.join("config").join("#{name}.yml").realpath
  # yaml = File.exist?(path) ? YAML.load_file(path) : {}

  # dict = schema.keys.each_with_object({}) { |key, memo|
  #   value = yaml.dig(key.name.to_s) 
  #   memo[key.name.to_sym] = value
  # }

  # require "resource_registry/entities/core_options"  
  # CoreContainer.namespace(:options) do |container|
  #   path  = container.config.root.join(container.config.system_dir)
  #   obj   = ResourceRegistry::Entities::CoreOptions.load_attr(path, "core_options")
  #   obj.to_hash.each_pair { |key, value| container.register("#{key}".to_sym, "#{value}") }
  # end
  # CoreContainer.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'
end