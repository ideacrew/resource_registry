require 'dry/system/container'

module ResourceRegistry
  
  class CoreContainer < Dry::System::Container
    configure do |config|
      config.name = :core
      config.default_namespace = :core
      config.root = Pathname.pwd.join('lib').realpath.freeze
      config.system_dir = "system"
      config.auto_register = %w[resource_registry/serializers resource_registry/stores]
    end

    load_paths!('system', 'resource_registry')
  end
end