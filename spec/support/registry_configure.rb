# frozen_string_literal: true

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
    },
    resource_registry: {
      resolver: {
        root: :enterprise,
        tenant: :dchbx,
        site: :shop_site,
        env: :production,
        application: :enroll_app
      }
    }
  }
end

path = Pathname.pwd.join('lib', 'system', 'config', 'configuration_options.yml')
ResourceRegistry::Registries::Transactions::LoadApplicationConfiguration.new.call(path)