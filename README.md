# ResourceRegistry

  ResourceRegistry is a library for system configuration, feature flipping and eventing. It offers an approach to custom configuration from a single codebase, supporting use cases such as: 

  * Customer-level preference profiles
  * Multitenancy
  * Access control based on privilidges and subscriptions

  ResourceRegistry is also intended to address 'logic sprawl' that can occur with minimally- or un-structured key/value system settings schemes along with improper abstraction code smell that often pops up when using Rails Concerns.

## Features

  * Use a Feature to group associated system code and configuration settings
  * Use a Taxonomy to structure Features and their associations
  * Access Features and their settings using a thread-safe key/value store
  * Enable/disable individual Features and groups/dependencies based on Taxonomy associations
  * Use YAML to seed Features and Taxonomies
  * Manage configuration settings on an environment basis, including: :development, :test and :production
  * Use multi-tenancy to switch between configuration settings for different tenants running in the same context
  * Autoload classes that support Command pattern, both single Operation and multi-step Transactions

## Compatibility

  * Ruby 2.6
  * Rails 5.2.4

### Installing on Rails

  Add this line to your project's Gemfile:

      gem 'resource_registry'

  And then execute:

      $ bundle

  Or install it yourself as:

      $ gem install resource_registry

  In your project build the directory tree to house configuration files:

      $ mkdir -p ./system/boot && mkdir -p ./system/config

  Then, create Resource Registry's initializer file:

      $ touch ./config/initializers/resource_registry.rb

## Usage

  ResourceRegistry uses Features to group system functions and settings into distinct units. Features can be individually configured and enabled/disabled.  

### Features


``` ruby
require 'resource_registry'

# Initialize registry
my_registry = ResourceRegistry::Registry.new

# Register a Feature with an item attribute that is invoked when key is resolved
stringify = ResourceRegistry::Feature.new(key: :stringify, item: ->(val){ val.to_s }, is_enabled: true)
my_registry.register_feature(stringify)

# Verify the Feature is registered and enabled
my_registry.feature_exist?('stringify')             # => true
my_registry.resolve_feature('stringify').enabled?   # => true

# Use its key to resolve and invoke the Feature
my_registry.resolve_feature('stringify') :my_symbol # => "my_symbol"
```

#### Detailed Example
```ruby
my_registry = ResourceRegistry::Registry.new

# Executable code to associate with the Feature
class ::Greeter
  def call(params)
    return "Hello #{params[:name]}"
  end
end

# Specify the code to invoke when the registry resolves the Feature key
greeter_instance = Greeter.new   

# Assign the Feature to a Taxonomy namespace 
ns = [:operations, :ai]

# Associate a Setting key/value pair with the Feature
scope_setting = {key: :scope, item: "online"}
 

# Register a Feature with a namespace and settings
greeter = ResourceRegistry::Feature.new(key:       :greeter, 
                                        item:      greeter_instance, 
                                        namespace: ns, 
                                        settings:  [scope_setting])

my_registry.register_feature(greeter)
# Use syntax shortcut to resolve the registered Feature
my_registry.resolve_feature(:greeter).namespace              # => "operations.ai"
my_registry.resolve_feature(:greeter).settings(:scope).to_h  # => {:key=>:scope, :item=>"online"}
my_registry.resolve_feature(:greeter) "Dolly"                # => "Hello Dolly"
```

### Feature Namepace

  Features in turn may be structured into a system model Taxonomy that defines associations and dependencies between them.


## Rails Integration

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

ResourceRegistry.configure do 
  {
    application: {
      config: {
        name: "App Name",
        root: Rails.root,
        system_dir: "system",
      },
      load_paths: ['system']
    },
    resource_registry: {
      resolver: {
        root: :enterprise,
        tenant: :dchbx,
        site: :primary,
        env: :production,
        application: :enroll
      }
    }
  }
end
```

  Configuration files are located in your project's ```system/config``` directory.  All Yaml files in and below this directory are autoloaded during the boot process.  Configuration settings may be organized into directories and files in any manner.  Values will properly load into the container hierarchy provided the file begins with a reference to an identifiable parent key.  

  An example of a simple configuration file:
  ```ruby
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

## Credits
  Based on [dry-system](https://dry-rb.org/gems/dry-system/) and [dry-validation](https://dry-rb.org/gems/dry-validation/1.0/)  ```

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
