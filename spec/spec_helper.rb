require "bundler/setup"
require "resource_registry"
require "pry-byebug"

# Set up the local context
# Dir['./spec/shared/app/models/organizations/*.rb'].sort.each { |file| require file }
# glob_pattern = File.join('./spec/shared/app', File.dirname(__FILE__), "features", "models", "services")

shared_resource_dirs = ["features", "models/organizations", "services/organizations"]
shared_resource_dirs.each do |dir|
  glob_pattern = File.join('.', 'spec', 'support', 'benefit_sponsors', 'app', dir, '*.rb')
  Dir.glob(glob_pattern).each { |file| require file }
end

begin
  require 'pry-byebug'
  rescue LoadError
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
