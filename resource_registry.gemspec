# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'resource_registry/version'

Gem::Specification.new do |spec|
  spec.name          = 'resource_registry'
  spec.version       = ResourceRegistry::VERSION
  spec.authors       = ['ipublic', 'Raghuram Ghanjala']
  spec.email         = ['info@ideacrew.com']

  spec.summary       = 'Configure and organize system settings as Features'
  spec.description   = 'Provides a Feature model to define, organize and retrieve application settings.
                            Features may be enabled/disabled, may include setting attributes of any
                            type and metadata settings designed to drive auto-display of confguration
                            settings.'
  spec.homepage      = 'https://github.com/ideacrew/resource_registry'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      `git ls-files -z`.split("\x0").reject do |f|
        f.match(%r{^(test|spec|features)/})
      end
    end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.7.3'

  spec.add_dependency 'bootsnap',                 '>= 1.13'
  spec.add_dependency 'deep_merge',               '>= 1.2.2'

  spec.add_dependency 'dry-auto_inject',          '>= 0.9.0'
  spec.add_dependency 'dry-configurable',         '>= 0.15'
  spec.add_dependency 'dry-container',            '~> 0.10.1'
  spec.add_dependency 'dry-matcher',              '~> 0.9.0'
  spec.add_dependency 'dry-monads',               '~> 1.4'
  spec.add_dependency 'dry-struct',               '~> 1.4.0'
  spec.add_dependency 'dry-types',                '~> 1.5.1'
  spec.add_dependency 'dry-validation',           '~> 1.8.1'

  spec.add_dependency 'i18n',                     '>= 0.7.0'
  spec.add_dependency 'mime-types'
  spec.add_dependency 'ox',                       '~> 2.0'

  # Dependency gems added for security purposes
  spec.add_dependency 'loofah',                   '>= 2.3.1'
  spec.add_dependency 'nokogiri',                 '>= 1.13.8'
  spec.add_dependency 'rack',                     '>= 2.2.4'
  spec.add_dependency 'rgl'

  # end of dependency gem security updates

  spec.add_development_dependency 'actionview',       '>= 6.1'
  spec.add_development_dependency 'activesupport',    '>= 6.1'
  spec.add_development_dependency 'mongoid',          '~> 7.3.5'
  spec.add_development_dependency 'timecop',          '~> 0.9'
end
