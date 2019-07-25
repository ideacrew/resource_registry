require "bundler/setup"

require 'simplecov'
SimpleCov.start if ENV["COVERAGE"]

# require "resource_registry"
require "pry-byebug"
require 'dry/container/stub'
require "timecop"

# ENV["RAILS_ENV"] = "test"

SPEC_ROOT = Pathname(__FILE__).dirname

Dir[SPEC_ROOT.join("support/*.rb").to_s].each(&method(:require))
Dir[SPEC_ROOT.join("shared_examples/*.rb").to_s].each(&method(:require))

# Application::Container.boot(:i18n)

# Set up the local context
# Dir['./spec/shared/app/models/organizations/*.rb'].sort.each { |file| require file }
# glob_pattern = File.join('./spec/shared/app', File.dirname(__FILE__), "features", "models", "services")

# shared_resource_dirs = ["features", "models/organizations", "services/organizations"]
# shared_resource_dirs.each do |dir|
#   glob_pattern = File.join('.', 'spec', 'support', 'benefit_sponsors', 'app', dir, '*.rb')
#   Dir.glob(glob_pattern).each { |file| require file }
# end

# begin
#   require 'pry-byebug'
#   rescue LoadError
# end


RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Many RSpec users commonly either run the entire suite or an individual
  # file, and it's useful to allow more verbose output when running an
  # individual spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = "doc"
  end

end
