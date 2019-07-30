require 'dry/system/container'

module ResourceRegistry

  ResourceRegistry.const_set('Registry', Dry::System::Container)

  require_relative 'local/transactions'
  require_relative 'local/operations'
  
  # CoreContainer.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'
end