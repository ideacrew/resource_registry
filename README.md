<!--
# @markup markdown
# @title README.md
# @author Dan Thomas
-->

# ResourceRegistry

[![Build Status](https://travis-ci.com/ideacrew/resource_registry.svg?branch=branch_0.7.0)](https://travis-ci.com/ideacrew/resource_registry)

  ResourceRegistry is a library for system configuration, feature flipping and eventing. It offers an approach to custom configuration for a single codebase, supporting use cases such as: 

  * Customer-level preference profiles
  * Multitenancy
  * Access control based on privilidges and subscriptions

  ResourceRegistry is intended to address 'logic sprawl' that can occur with minimally- or un-structured key/value system settings schemes.  It offers an
  alternative to code obfuscation issues that often pops up when using Rails Concerns.

## Gem Features

  * Group associated system code and configuration settings as a Feature
  * Define a namespace taxonomy to associate and nest Features and dependencies
  * Enable/disable individual Features 
  * Store metadata values for a Feature that support auto generation of a configuration UI
  * Access Features and their attribute values using a thread-safe key/value store
  * Use YAML files to seed Features and namespaces

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

## Feature

  ResourceRegistry uses a Feature to group related system functions and settings. Featurse are composed of the following high level attributes:

  * key [Symbol] 'key' of the Feature's key/value pair.  This is the Feature's identifier and must be unique
  * item [Any] 'value' of the Feature's key/value pair.   May be a static value, proc, class instance and may include an options hash
  * namespace [Array<Symbol>] an ordered list that supports optional taxonomy for relationships between Features
  * is_enabled [Boolean] indicator whether the Feature is accessible in the current configuration
  * settings [Array<Hash>] a list of key/item pairs associated with the Feature
  * meta [Hash] a set of attributes to store configuration values and drive their presentation in User Interface

  Here is an example Feature definition in YAML format.  Note the settings ```effective_period``` value is an expression:

``` ruby
  - namespace:
    - :enroll_app
    - :aca_shop_market
    - :benefit_market_catalog
    - :catalog_2019
    - :contribution_model_criteria
    features:
      - key: :initial_sponsor_jan_default_2019
        item: :contribution_model_criterion
        is_enabled: true
        settings:
          - key: :contribution_model_key
            item: :zero_percent_sponsor_fixed_percent_contribution_model
          - key: :benefit_application_kind
            item: :initial
          - key: :effective_period
            item: <%= Date.new(2019,1,1)..Date.new(2019,1,31) %>
          - key: :order
            item: 1
          - key: :default
            item: false
          - key: :renewal_criterion_key
            item: :initial_sponsor_jan_default
```

  ### Registering Features 

  Features are most useful when they're loaded into a registry for runtime access.  For example:

``` ruby
require 'resource_registry'

# Initialize registry
my_registry = ResourceRegistry::Registry.new

# Register a Feature with an item attribute that is invoked when key is resolved
stringify = ResourceRegistry::Feature.new(key: :stringify, item: ->(val){ val.to_s }, is_enabled: true)
my_registry.register_feature(stringify)

# Verify the Feature is registered and enabled
my_registry.feature?('stringify')             # => true
my_registry.resolve_feature('stringify').enabled?   # => true

# Use its key to resolve and invoke the Feature with argument passed as block
my_registry.resolve_feature('stringify') {:my_symbol} # => "my_symbol"
```

### Detailed Example
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
 

# Define a Feature with a namespace and settings
greeter = ResourceRegistry::Feature.new(key:       :greeter, 
                                        item:      greeter_instance, 
                                        namespace: ns, 
                                        settings:  [scope_setting])

# Add Feature to the Registry
my_registry.register_feature(greeter)

# Resolve Feature attributes using its key (use syntax shortcut)
my_registry[:greeter].namespace              # => "operations.ai"
my_registry[:greeter].settings(:scope).to_h  # => {:key=>:scope, :item=>"online"}
my_registry[:greeter] {"Dolly"}              # => "Hello Dolly"
```

### Namepace

  Use the optional Feature#namespace attribute to organize Features.  Namespaces support enable you to define a structure to group Features into a logical structure or taxonomy that can help with code clarity.  For example:

``` ruby
  my_species = ResourceRegistry::Feature.new( key:      :species, 
                                              item:     :Operations::Species::Create.new,
                                              is_enabled: true,
                                              namespace: [:kingdom, :phylum, :class, :order, :family, :genus])
  my_registry.register_feature(my_species)
```

Namespaced Features respect their anscesters with regard to code access.  For instance ```Feature#enabled?``` will check not only the referenced Feature, but traverse all ancestors in its namespace.  If any of the referenced Feature's anscestors is disabled, then the referenced Feature is considered disabled -- regardless of whether ```is_enabled``` is set to ```true``` or ```false```.

For instance, extending the ```species``` Feature example above:

``` ruby
  my_phylum = ResourceRegistry::Feature.new(key:      :phylum, 
                                            item:     :Operations::Phylum::Create.new,
                                            is_enabled: false,
                                            namespace: [:kingdom])
  my_registry.register_feature(my_phylum)
```

Here the ```my_registry[:my_phylum].is_enabled? == false```.  As it's a namespace ancestor to the ```my_registry[:species]```, ```my_registry[:species].is_enabled? == false``` also.

Namespaces serve another purpose: enabling auto-generation of Admin UI configuration settings.  This is a future function that uses Namespace in combination with Meta attributes to build the UI forms.

## Rails Integration

  A registry is configured and loaded when your application starts.  

## Configuration

  The initializer and configuration files manage the setup and loading process. 

  Configuration files are located in your project's ```system/config``` directory.  All Yaml files in and below this directory are autoloaded during the boot process.  Configuration settings may be organized into directories and files in any manner.  Values will properly load into the container hierarchy provided the file begins with a reference to an identifiable parent key.  

  An example of a simple configuration file:
  ```ruby
# ./system/config/enterprise.yml

  ```

  ## Defining Configuration Settings 

  ### UI-ready configuration settings

## Credits
  Based on [dry-system](https://dry-rb.org/gems/dry-system/) and [dry-validation](https://dry-rb.org/gems/dry-validation/1.0/)  ```

## Future Features

  * Taxonomy: support namespace structures and validations
  * Subscription
  * Bootable infrastructure components

## Development

  After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

  To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

  Bug reports and pull requests are welcome on GitHub at https://github.com/ideacrew/resource_registry.

## License

  The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
