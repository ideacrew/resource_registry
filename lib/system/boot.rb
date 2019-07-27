# Initialize container with core system settings
module ResourceRegistry

  path = Pathname.new(__dir__).join('config', 'private_options.yml')
  params = YAML.load_file(path)

  registry_validator  = ResourceRegistry::Registries::Validation::RegistrySchema.new
  registry_validation = registry_validator.call(params)

  raise "Invalid Params" unless registry_validation.success?

  PrivateRegistry = ResourceRegistry::Registries::Registry.new(registry_validation)

  require_relative "local/inject"
  require_relative "local/persistence"

  PrivateRegistry.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'

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