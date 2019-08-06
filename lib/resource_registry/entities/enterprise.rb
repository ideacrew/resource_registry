module ResourceRegistry
  module Entities
    class Enterprise
      extend Dry::Initializer

        option :tenants, [], optional: true do
          option :tenant, optional: true
        end

        option :features, [], optional: true do
          option :feature, optional: true
        end
      end

  end
end