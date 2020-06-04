def gem_available?(gem_name, version = nil)
  version.nil? ? gem(gem_name) : gem(gem_name, version)
rescue Gem::LoadError
  false
end

require 'rubygems/dependency_installer'

installer = Gem::DependencyInstaller.new

if gem_available?('activerecord')
  installer.install 'activerecord'
  
  require 'resource_registry/models/active_record/feature'
  require 'resource_registry/models/active_record/setting'
  require 'resource_registry/models/active_record/meta'
end

if gem_available?('mongoid')
  installer.install 'mongoid'

  require 'resource_registry/models/mongoid/feature'
  require 'resource_registry/models/mongoid/setting'
  require 'resource_registry/models/mongoid/meta'
end

require 'resource_registry/helpers/view_controls'
# require 'resource_registry/controllers/features_controller'

module ResourceRegistry
  # :nodoc:
  class Railtie < Rails::Railtie
    
    initializer 'resource_registry.helper' do |_app|
      ActionView::Base.send :include, RegistryViewControls
    end
  end
end





