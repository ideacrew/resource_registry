# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module ActiveRecord
      # Instantiate a new Dry::Container object
      class Persist
        send(:include, Dry::Monads[:result, :do])

        # @param [Dry::Struct] feature_entity feature entity object
        # @return [ResourceRegistry::Mongoid::Feature] persisted feature record wrapped in Dry::Monads::Result
        def call(feature_entity)
          feature  = yield persist(feature_entity)

          Success(feature)
        end

        private

        def persist(feature_entity)
          # if registry.db_connection&.table_exists?(:resource_registry_features)
          feature = ResourceRegistry::ActiveRecord::Feature.where(key: feature.key).first
          feature = ResourceRegistry::ActiveRecord::Feature.new(feature.to_h).save unless feature
          # else
          #   result = ResourceRegistry::Operations::Features::Create.new.call(feature_record.to_h)
          #   feature = result.success if result.success? # TODO: Verify Failure Scenario
          # end
          # end

          Success(feature)
        end
      end
    end
  end
end
