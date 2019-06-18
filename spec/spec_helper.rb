require "bundler/setup"
require "resource_registry"
require "pry-byebug"


# Set up the local context
# Dir['./spec/resource_registry/subscriptions/*.rb'].sort.each { |file| require file }


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
