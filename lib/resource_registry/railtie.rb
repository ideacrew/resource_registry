require 'resource_registry/helpers/view_controls'


module ResourceRegistry
  # :nodoc:
  class Railtie < Rails::Railtie
    initializer 'resource_registry.helper' do |_app|
      ActionView::Base.send :include, RegistryViewControls
    end
  end
end