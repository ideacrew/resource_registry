# frozen_string_literal: true

def gem_available?(gem_name)
  require(gem_name)
rescue LoadError
  false
end

require 'rubygems/dependency_installer'

if gem_available?('mongoid')
  # installer.install 'mongoid'

  # require 'resource_registry/models/mongoid/feature'
  # require 'resource_registry/models/mongoid/setting'
  # require 'resource_registry/models/mongoid/meta'
elsif gem_available?('activerecord')
  require 'resource_registry/models/active_record/feature'
  require 'resource_registry/models/active_record/setting'
  require 'resource_registry/models/active_record/meta'
end

require 'resource_registry/helpers/view_controls'
# require 'resource_registry/controllers/features_controller'

module ResourceRegistry
  # :nodoc:
  class Railtie < Rails::Railtie

    rake_tasks do
      load 'resource_registry/tasks/purge.rake'
    end


    initializer 'resource_registry.helper' do |_app|
      ActionView::Base.send :include, RegistryViewControls
    end
  end
end
