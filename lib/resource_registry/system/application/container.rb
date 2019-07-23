require 'dry/system/container'

module Application
  class Container < Dry::System::Container

    configure do |config|
      config.name = :core
      # config.root = Rails.root
      # config.auto_register = %w[lib/authentication]
    end

    # load_paths! "lib", "system"
  end
end
