require_relative "application/container"
require_relative "application/inject"

Application::Container.finalize!

require_relative "application/inject"
# require_relative "../system/boot"

# system_paths = Pathname(__FILE__).dirname.join("../../resource_registry").realpath
# Dir[system_paths].each do |f|
#   require "#{f}/system/boot"
# end

require_relative "application/application"
