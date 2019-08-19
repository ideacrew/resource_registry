ResourceRegistry.configure do
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

path = Pathname.pwd.join('lib', 'system', 'config', 'configuration_options.yml')
ResourceRegistry::Registries::Transactions::LoadApplicationConfiguration.new.call(path)