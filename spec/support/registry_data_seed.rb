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
end