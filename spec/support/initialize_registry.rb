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