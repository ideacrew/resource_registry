require 'yaml'

module RegistryDataSeed

  def options_hash
    return @options_hash if defined? @options_hash
    @options_hash = YAML.load(IO.read(File.open(options_file_path)))
  end

  def configuration_options_hash
    return @configuration_options if defined? @configuration_options
    @configuration_options = YAML.load(IO.read(File.open(configuration_file_path))).deep_symbolize_keys!
  end

  def options_file_path
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'client', 'enterprise.yml')
  end

  def configuration_file_path
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'config', 'config.yml')
  end

  def option_files_dir
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'client')
  end

  def reset_registry
    Kernel.send(:remove_const, 'Registry') if defined? Registry
  end

  def override_config
    {
      application: {
        config: {
          name: "EdiApp",
          default_namespace: "options",
          root: Pathname.pwd.join('spec', 'rails_app'),
          system_dir: "system",
          auto_register: []
          },
        load_paths: ['system']
      }
    }
  end

  def initialize_registry
    ResourceRegistry.configure do
      override_config
    end
  end

  def configure_registry
    initialize_registry

    path = Pathname.pwd.join('lib', 'system', 'config', 'configuration_options.yml')
    ResourceRegistry::Registries::Transactions::LoadApplicationConfiguration.new.call(path)

    dir = Pathname.pwd.join('lib', 'system', 'dependencies')
    result = ResourceRegistry::Stores::Operations::ListPath.new.call(dir)
    result.value!.each{|path| load path}
  end
end