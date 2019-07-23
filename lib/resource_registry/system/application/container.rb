require 'dry/system/container'

module Application
  class Container < Dry::System::Container

    configure do |config|
      config.name = :core
      config.root = Pathname(__FILE__).join("../..").realpath.dirname
      config.auto_register = %w[resource_registry/serializers resource_registry/stores]
    end

    load_paths! "system"
  end
end
