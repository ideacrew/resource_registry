# frozen_string_literal: true

require 'yaml'

module RegistryDataSeed
  # rubocop:disable Security/YAMLLoad
  def options_hash
    return @options_hash if defined? @options_hash
    @options_hash = YAML.load(IO.read(File.open(options_file_path)))
  end

  def configuration_options_hash
    return @configuration_options if defined? @configuration_options
    @configuration_options = YAML.load(IO.read(File.open(configuration_file_path))).deep_symbolize_keys!
  end
  # rubocop:enable Security/YAMLLoad

  def options_file_path
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'client', 'enterprise.yml')
  end

  def features_folder_path
    Pathname.pwd.join('spec', 'rails_app', 'system', 'config', 'templates', 'features')
  end

  def configuration_file_path
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'config', 'config.yml')
  end

  def invalid_feature_template_path
    Pathname.pwd.join('spec', 'rails_app', 'system', 'config', 'templates', 'features','invalid', 'aca_shop_market.yml')
  end

  def feature_template_path
    Pathname.pwd.join('spec', 'rails_app', 'system', 'config', 'templates', 'features', 'aca_shop_market', 'aca_shop_market.yml')
  end

  def feature_group_template_path
    Pathname.pwd.join('spec', 'rails_app', 'system', 'config', 'templates', 'features','aca_shop_market', 'feature_group.yml')
  end

  def option_files_dir
    Pathname.pwd.join('spec', 'db', 'seedfiles', 'client')
  end

  def reset_registry
    Kernel.send(:remove_const, 'Registry') if defined? Registry
  end

  def resolver_options_hash
    {
      resource_registry: {
        resolver: {
          root: :enterprise,
          tenant: :dchbx,
          site: :shop_site,
          env: :production,
          application: :enroll_app
        },
        load_application_settings: true
      }
    }
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
    }.merge(resolver_options_hash)
  end

  def configuration_options_with_resolver_options
    options = configuration_options_hash
    options[:resource_registry].merge!(resolver_options_hash[:resource_registry])
    options
  end

  # def initialize_registry
  #   ResourceRegistry.configure do
  #     override_config
  #   end
  # end

  def load_dependencies
    dir = Pathname.pwd.join('lib', 'system', 'dependencies')
    result = ResourceRegistry::Stores::Operations::ListPath.new.call(dir)
    result.value!.each{|path| load path}
  end

  def configure_registry
    initialize_registry
    path = Pathname.pwd.join('lib', 'system', 'config', 'configuration_options.yml')
    ResourceRegistry::Registries::Transactions::LoadApplicationConfiguration.new.call(path)
    # load_dependencies
  end

  # def create_registry
  #   initialize_registry
  #   path = Pathname.pwd.join('lib', 'system', 'config', 'configuration_options.yml')
  #   ResourceRegistry::Registries::Transactions::Create.new.call(path)
  # end
end
