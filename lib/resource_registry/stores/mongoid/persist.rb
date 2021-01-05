# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Mongoid
      # Instantiate a new Dry::Container object
      class Persist
        send(:include, Dry::Monads[:result, :do])

        # @param [ResourceRegistry::Entities::Registry] container the container instance to which the constant will be assigned
        # @param [String] constant_name the name to assign to the container and its associated dependency injector
        # @return [Dry::Container] A non-finalized Dry::Container with associated configuration values wrapped in Dry::Monads::Result
        def call(feature_entity, registry)
          feature  = yield persist(feature_entity, registry)

          Success(feature)
        end

        private

        def persist(feature_entity, registry)
          feature = ResourceRegistry::Mongoid::Feature.where(key: feature_entity.key).first
          # feature&.delete
          feature = ResourceRegistry::Mongoid::Feature.new(feature_entity.to_h).save unless feature

          # if feature.blank?
          #   ResourceRegistry::Mongoid::Feature.new(feature.to_h).save
          # else
          #   feature.update_attributes(feature.to_h)
          #   result = ResourceRegistry::Operations::Features::Create.new.call(feature.to_h)
          #   feature = result.success if result.success? # TODO: Verify Failure Scenario
          # end
          Success(feature)
        end
      end
    end
  end
end

