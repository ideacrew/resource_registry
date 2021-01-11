# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Mongoid
      # Instantiate a new Dry::Container object
      class Persist
        send(:include, Dry::Monads[:result, :do, :try])

        # @param [ResourceRegistry::Entities::Registry] container the container instance to which the constant will be assigned
        # @param [String] constant_name the name to assign to the container and its associated dependency injector
        # @return [Dry::Container] A non-finalized Dry::Container with associated configuration values wrapped in Dry::Monads::Result
        def call(entity)
          feature = yield find(entity)
          feature = yield persist(entity, feature) 
          
          Success(feature)
        end

        private

        def find(entity)
          feature = ResourceRegistry::Mongoid::Feature.where(key: entity.key).first
          
          Success(feature)
        end

        def persist(entity, feature)
          if feature.blank?
            create(entity)
          else
            update(entity, feature)
          end
        end

        def create(entity)
          Try {
            ResourceRegistry::Mongoid::Feature.new(entity.to_h).save
          }.to_result
        end

        def update(entity, feature)
          Try {
            feature.is_enabled = entity.is_enabled
            entity.settings.each do |setting_entity|
              if setting = feature.settings.detect{|setting| setting.key == setting_entity.key}
                setting.item = setting_entity.item
              else
                feature.settings.build(setting_entity.to_h)
              end
            end
            feature.save
          }.to_result
        end
      end
    end
  end
end

