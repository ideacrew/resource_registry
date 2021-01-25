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
        def call(entity, registry, params = {})
          record = yield find(entity, registry, params[:filter])
          record = yield persist(entity, record)
          
          Success(record)
        end

        private

        def find(entity, registry, filter_params =  nil)
          record = if filter_params
            registry[entity.key]{ filter_params }.success[:record]
          else
            ResourceRegistry::Mongoid::Feature.where(key: entity.key).first
          end

          Success(record)
        end

        def persist(entity, record)
          if record.blank?
            create(entity)
          else
            update(entity, record)
          end
        end

        def create(entity)
          Try {
            ResourceRegistry::Mongoid::Feature.new(entity.to_h).save
          }.to_result
        end

        def update(entity, record)
          Try {
            if record.class.to_s.match?(/ResourceRegistry/)
              record.is_enabled = entity.is_enabled
              entity.settings.each do |setting_entity|
                if setting = record.settings.detect{|setting| setting.key == setting_entity.key}
                  setting.item = setting_entity.item
                else
                  record.settings.build(setting_entity.to_h)
                end
              end
            else
              attributes = entity.settings.reduce({}) do |attrs, setting|
                attrs[setting.key] = setting.item
                attrs
              end
              record.assign_attributes(attributes)
            end
            record.save(validate: false)
            record
          }.to_result
        end
      end
    end
  end
end

