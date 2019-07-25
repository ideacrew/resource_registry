require 'dry/system/container'

module ResourceRegistry
  class Container < Dry::System::Container

    configure do |config|
      config.name = :core
      config.default_namespace = :core
      config.root = Pathname.pwd.join('lib').realpath.freeze
      config.system_dir = "resource_registry/system"
      # config.root = Pathname.pwd.join('lib').join('resource_registry').realpath.freeze

      config.auto_register = %w[resource_registry/serializers resource_registry/stores]
    end

    load_paths!('resource_registry')
  end
end