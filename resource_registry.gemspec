# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "resource_registry/version"

Gem::Specification.new do |spec|
  spec.name          = "resource_registry"
  spec.version       = ResourceRegistry::VERSION
  spec.authors       = ["Dan Thomas", "Raghuram Ghanjala"]
  spec.email         = ["dan@ideacrew.com"]

  spec.summary       = "Configure and organize system settings as Features}"
  spec.description   = "Provides a Feature model to define, organize and retrieve application settings.
                            Features may be enabled/disabled, may include setting attributes of any
                            type and metadata settings designed to drive auto-display of confguration
                            settings."
  spec.homepage      = "https://github.com/ideacrew/resource_registry"
  spec.license       = "MIT"


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.5.1'

  spec.add_dependency 'dry-validation',           '~> 1.2'
  spec.add_dependency 'dry-struct',               '~> 1.0'
  spec.add_dependency 'dry-types',                '~> 1.0'
  spec.add_dependency 'dry-configurable',         '0.9'

  spec.add_dependency 'dry-container',            '~> 0.7'
  spec.add_dependency 'deep_merge',               '>= 1.0.0'

  # Dependency gems added for security purposes
  spec.add_dependency 'nokogiri',                 ">= 1.9.1"
  spec.add_dependency "rack",                     ">= 1.6.13"
  spec.add_dependency 'dry-monads',               '~> 1.2'
  spec.add_dependency 'dry-matcher',              '~> 0.7'

  spec.add_dependency "loofah",                   ">= 2.3.1"
  spec.add_development_dependency "actionview",   ">= 5.2.4.2"
  # end of dependency gem security updates

  spec.add_dependency 'i18n',                     '>= 0.7.0'
  spec.add_dependency 'ox',                       '~> 2.0'
  spec.add_dependency 'bootsnap',                 '~> 1.0'
  spec.add_dependency 'mime-types'

  spec.add_development_dependency "bundler",          "~> 2.0"
  spec.add_development_dependency 'rake',             '~> 12.0'
  spec.add_development_dependency 'rspec',            '~> 3.9'
  spec.add_development_dependency 'rspec-rails',      '~> 3.9'
  spec.add_development_dependency 'mongoid',          '~> 6.0'
  spec.add_development_dependency 'activesupport',    '~> 5.2.4'
  spec.add_development_dependency "simplecov" #,  '~> 1.0'
  spec.add_development_dependency "database_cleaner", '~> 1.7'
  spec.add_development_dependency "timecop",          '~> 0.9'
  spec.add_development_dependency "rubocop",          '~> 1.17.0'
  spec.add_development_dependency "yard",         "~> 0.9"
  spec.add_development_dependency 'pry-byebug'

end
