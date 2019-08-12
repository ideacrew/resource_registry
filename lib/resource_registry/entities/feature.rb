module ResourceRegistry
  module Entities
    
    class Feature
      extend Dry::Initializer

        option :key          
        option :is_required
        option :alt_key,        optional: true
        option :title,          optional: true
        option :description,    optional: true
        option :parent,         optional: true

        option :environments, [], optional: true do
          option :key
          option :is_enabled
          option :registry,   optional: true #,   type: Dry::Types::Array.of(RegistryConstructor), optional: true
          option :options,    optional: true #,   type: Dry::Types::Array.of(OptionConstructor), optional: true
          option :features,   optional: true #,   type: Dry::Types::Array.of(FeatureConstructor), optional: true
        end
      end
    end
  end
end