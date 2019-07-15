module ResourceRegistry
  module Options
    class Site < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,               Types::Symbol
      attribute :title?,            Types::Strict::String
      attribute :applications,      Types::Array.of(Options::Application)
      attribute :tenants,           Types::Array.of(Options::Tenant)

      # attribute :options do
      #   attribute :key,     Types::Symbol
      #   attribute :default, Options::Option
      #   attribute :value?,  Options::Option
      # end

      def load_container
        container = Dry::Container.new
        container.register(:key, key)
        applications.each do |application|
          container.merge(application.to_container)
        end
        tenants.each do |tenant|
          container.merge(tenant.to_container)
        end
        container
      end

      # features = [
      #   ResourceRegistry::Options::Feature.new(key: :aca_shop, 
      #     namespaces: {
      #       name: 'open_enrollment', 
      #       options: [ResourceRegistry::Options::Option.new(key: :begin_on, type: :integer, default: '1')]
      #     }
      #   ),
      #   ResourceRegistry::Options::Feature.new(key: :aca_individual, 
      #     namespaces: {
      #       name: 'open_enrollment', 
      #       options: [ResourceRegistry::Options::Option.new(key: :begin_on, type: :integer, default: '1')]
      #     }
      #   )
      # ]

      # tenants = [
      #   ResourceRegistry::Options::Tenant.new(key: :dc, title: 'DC Health Link'),
      #   ResourceRegistry::Options::Tenant.new(key: :cca, title: 'Health Connector')
      # ]

      # applications = [ ResourceRegistry::Options::Application.new(key: :ea, title: 'DC Health Link', features: features) ]
      # site = ResourceRegistry::Options::Site.new(key: :enroll, title: "Enroll", applications: applications, tenants: tenants)

    end
  end
end
