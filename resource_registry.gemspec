
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "resource_registry/version"

Gem::Specification.new do |spec|
  spec.name          = "resource_registry"
  spec.version       = ResourceRegistry::VERSION
  spec.authors       = ["Dan Thomas"]
  spec.email         = ["dan@ideacrew.com"]

  spec.summary       = %q{Configure access to component features and custom behaviors on a multi-tenant basis}
  spec.description   = %q{Provides ability to define and access multiple customer settings in the same instance,
                            supporting thread-safe configurations that enable/disable access to features and dynamic
                            changes to settings using a syntax that avoids inline conditionals.
                          }
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

  spec.required_ruby_version = '>= 2.5.0'

  spec.add_dependency 'dry-configurable',         '~> 0.8'
  spec.add_dependency 'dry-container',            '~> 0.7'
  spec.add_dependency 'dry-monads',               '~> 1.2'
  spec.add_dependency 'dry-validation',           '~> 1.0'
  spec.add_dependency 'dry-inflector',            '~> 0.1'

  spec.add_development_dependency "bundler",      "~> 2.0"
  spec.add_development_dependency 'rake',         '~> 12.0'
  spec.add_development_dependency 'rspec',        '~> 3.0'
  spec.add_development_dependency 'rspec-rails',  '~> 3.0'
  spec.add_development_dependency 'pry-byebug',   '~> 3.0'
  spec.add_development_dependency 'mongoid',      '~> 7.0'

end
