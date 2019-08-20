  # ResourceRegistry

  Resource Registry is a library for system configuration and dependency management based on [dry-system](https://dry-rb.org/gems/dry-system/) and [dry-validation](https://dry-rb.org/gems/dry-validation/1.0/).  It provides an enterprise-down taxonomy for organizing, defining and configuring an application's behavior, supporting single monolith and multiple component microservice architectures alike.

  ## Features

  * Create and access system configuration settings using a thread-safe key/value store
  * Organize settings into namespaces for readability and to help avoid key naming conflicts 
  * Use YAML to seed configuration setting namespaces, keys and values  
  * Group related settings and enable/disable them as a collection
  * Manage configuration settings on an environment basis, including: :development, :test and :production
  * Use multi-tenancy to switch between configuration settings for different tenants running in the same context
  * Autoload classes that support Command pattern, both single Operation and multi-step Transactions


  ## Compatibility

  * Ruby >= 2.6

  ### Installing on Rails

  Add this line to your project's Gemfile:

  ```ruby
  gem 'resource_registry'
  ```

  And then execute:

      $ bundle

  Or install it yourself as:

      $ gem install resource_registry

  In your project build the directory tree to house configuration files:

      $ mkdir -p ./system/boot && mkdir -p ./system/config

  Then, create Resource Registry's initializer file:

      $ touch ./config/initializers/resource_registry.rb

  ## Usage

  A registry is configured and loaded when your application starts.  At runtime, a value may be accessed directly by referencing its key or indirectly using the registry's associated dependency injector.  By default, the registry object is assigned to the constant: ```Registry``` (this setting may be changed in the initializer file). 

  Here is an example of directly accessing a configuration setting using the ```#resolve``` method and the key ([]) shortcut:

  ```
  Registry.resolve "enterprise.dchbx.shop_site.production.policies_url"
  => "https://dchealthlink.com/"

  Registry[:"enterprise.dchbx.shop_site.production.policies_url"]
  => "https://dchealthlink.com/"
  ```

  Configuration settings for a registry are accessed via ```#config```:

  ```
  Registry.config
  ```

  <details><summary>Click for returned values</summary>
  <p>

  ```
  => #<#<Class:0x00007f871d290968>:0x00007f871d290710
   @config=
    {:registry=>
      #<Dry::Container::Registry:0x00007f871e2018c0 @_mutex=#<Thread::Mutex:0x00007f871e201898>, @factory=#<Dry::Container::Item::Factory:0x00007f86ddacb050>>,
     :resolver=>#<Dry::Container::Resolver:0x00007f871e2016e0>,
     :namespace_separator=>".",
     :name=>"EdiApp",
     :default_namespace=>"options",
     :root=>#<Pathname:/Users/dthomas/Documents/dev/resource_registry/spec/rails_app>,
     :system_dir=>"system",
     :registrations_dir=>"container",
     :auto_register=>[],
     :loader=>Dry::System::Loader,
     :booter=>Dry::System::Booter,
     :auto_registrar=>Dry::System::AutoRegistrar,
     :manual_registrar=>Dry::System::ManualRegistrar,
     :importer=>Dry::System::Importer,
     :components=>{}},
   @defined=true,
   @lock=#<Thread::Mutex:0x00007f871d2906c0>>
  ```

  </p>
  </details>

  Use the ```#keys``` method to list all key values in a registry:

  ```
  Registry.keys
  ```

  <details><summary>Click for returned values</summary>
  <p>

  ```
  => ["resource_registry.config.name",
   "resource_registry.config.default_namespace",
   "resource_registry.config.root",
   "resource_registry.config.system_dir",
   "resource_registry.load_paths",
   "enterprise.dchbx.shop_site.production.copyright_period_start",
   "enterprise.dchbx.shop_site.production.policies_url",
   "enterprise.dchbx.shop_site.production.faqs_url",
   "enterprise.dchbx.shop_site.production.help_url",
   "enterprise.dchbx.shop_site.production.business_resource_center_url",
   "enterprise.dchbx.shop_site.production.nondiscrimination_notice_url",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.small_market_employee_count_maximumt",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.employer_contribution_percent_minimum",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.employer_dental_contribution_percent_minimumt",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.employer_family_contribution_percent_minimum",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2017.month_1.open_enrollment_begin_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2017.month_1.open_enrollment_end_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2017.month_1.binder_payment_due_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2017.month_2.open_enrollment_begin_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2017.month_2.open_enrollment_end_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2017.month_2.binder_payment_due_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2018.month_1.open_enrollment_begin_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2018.month_1.open_enrollment_end_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2018.month_1.binder_payment_due_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2018.month_2.open_enrollment_begin_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2018.month_2.open_enrollment_end_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2018.month_2.binder_payment_due_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2019.month_1.open_enrollment_begin_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2019.month_1.open_enrollment_end_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2019.month_1.binder_payment_due_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2019.month_2.open_enrollment_begin_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2019.month_2.open_enrollment_end_dom",
   "enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.benefit_market_catalog_2019.month_2.binder_payment_due_dom"]
  ```

  </p>
  </details>

  ### Dependency Injection
  By default, the dependency injector object associated with the Registry is assigned to the constant: ```Registry.injector``` (this setting may be changed in the initializer file). 

  Resource Registry uses [dry-auto_inject](https://dry-rb.org/gems/dry-auto_inject/) to support dependency injection.  See documentation on the dry website for more information.


  ## Configuration

  The initializer and configuration files manage the setup and loading process. The initializer file manages configuration options, including:

  * Container boot configuration settings
  * Constant names for the registry and dependency injector
  * Setting value extensions and overrides 

  An example initialization file:

  ```
  # ./config/initializers/resource_registry.rb



  ```

  Configuration files are located in your project's ```system/config``` directory.  All Yaml files in and below this directory are autoloaded during the boot process.  Configuration settings may be organized into directories and files in any manner.  Values will properly load into the container hierarchy provided the file begins with a reference to an identifiable parent key.  

  An example of a simple configuration file:
  ```
  # ./system/config/enterprise.yml

  namespace: 
    key: :enterprise
    settings:
      - key: :tenant_keys
        default: []
    namespaces:
      - key: :tenants
      - key: :features
  ```

  ## Taxonomy
  Resource Registry classifies configuration settings into the following structure:

  1. **Enterprise:** top level entry providing global information about the application solution and hosting infrastructure. 
     1. Has one Registry (managed via Registry#config)
     1. Has many Tenants
     1. Has many Options
  1. **Tenant:** unique customer or account within an Enterprise.  
     1. Has many Sites
     1. Has many Subscriptions
     1. Has many Options
  1. **Site:** a Tenant's deployment under a single domain name. For example, a Tenant may maintain separate sites for ACA Individual and SHOP markets
     1. Has many Environments
     1. Has many Options
  1. **Environment:** stages associated with code maturity in the Software Development Lifecycle.  Enumerated values: :development, :test, :production
     1. Has many Features
     1. Has many Options
  1. **Feature:** a defined software component or function.  Features may be nested, e.g.: "ACA SHOP Market" Feature may have an "Employer Attestation" Feature
     1. Has one Registry
     1. Has many Features
     1. Has many Options
  1. **Registry:** a constrained list of configuration settings used to initialize a Registry or individual Feature
     1. Has many Options
  1. **Option:** registry and user-defined application configuration settings
     1. Has many Namespaces (aka Option)
     1. Has many Settings

  ## Defining Configuration Settings 

  ### UI-ready configuration settings


  ## Future Features

  * Subscription
  * Bootable infrastructure components


  ## Development

  After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

  To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

  ## Contributing

  Bug reports and pull requests are welcome on GitHub at https://github.com/ideacrew/resource_registry.

  ## License

  The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
