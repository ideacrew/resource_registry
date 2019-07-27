require 'dry/system/container'

module ResourceRegistry

  class CoreContainer < Dry::System::Container
    configure do |config|
      config.name = :core
      config.default_namespace = :core
      # config.root = root.join('lib').realpath.freeze
      config.root = Pathname(File.dirname __dir__).join('..')
      config.system_dir = "system"
      config.auto_register = %w[resource_registry/serializers resource_registry/stores]
    end

    load_paths!('system', 'resource_registry')
  end
end