# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Mongoid
      # Instantiate a new Dry::Container object
      class Update
        send(:include, Dry::Monads[:result, :do])

        # @param [Dry::Struct] feature_entity feature entity object
        # @return [ResourceRegistry::Mongoid::Feature] persisted feature record wrapped in Dry::Monads::Result
        def call(feature_entity)
          feature  = yield update(feature_entity)

          Success(feature)
        end

        private

        def update(feature_entity)
          feature = ResourceRegistry::Mongoid::Feature.where(key: feature_entity.key).first
          feature.is_enabled = feature_entity.is_enabled

          feature_entity.settings.each do |setting_entity|
            if setting = feature.settings.detect{|setting| setting.key == setting_entity.key}
              setting.item = setting_entity.item
            else
              feature.settings.build(setting_entity.to_h)
            end
          end
          feature.save

          Success(feature)
        end
      end
    end
  end
end
