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

    end
  end
end
