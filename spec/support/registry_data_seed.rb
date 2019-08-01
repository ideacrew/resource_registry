require 'yaml'

module RegistryDataSeed

  def options_hash
    return @options_hash if defined? @options_hash
    @options_hash = YAML.load(IO.read(File.open(options_file_path)))
  end

  def configuration_options_hash
    return @configuration_options if defined? @configuration_options
    @configuration_options = YAML.load(IO.read(File.open(configuration_file_path)))
  end

  def options_file_path
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'client', 'aca_site.yml')
  end

  def configuration_file_path
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'config', 'config.yml')
  end

  def option_files_dir
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'client')
  end

  def reset_registry
    Kernel.send(:remove_const, 'Registry')
    ResourceRegistry.send(:remove_const, 'RegistryInject')
    ResourceRegistry.send(:remove_const, 'Container')
    
    load Pathname.pwd.join('lib', 'system', 'boot.rb')
    load Pathname.pwd.join('lib', 'system', 'local', 'transactions.rb')
    load Pathname.pwd.join('lib', 'system', 'local', 'operations.rb')
  end
end