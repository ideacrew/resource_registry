# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Container
      # Instantiate a new Dry::Container object
      class Update
        send(:include, Dry::Monads[:result, :do])

        # @param [ResourceRegistry::Entities::Registry] container the container instance to which the constant will be assigned
        # @param [String] constant_name the name to assign to the container and its associated dependency injector
        # @return [Dry::Container] A non-finalized Dry::Container with associated configuration values wrapped in Dry::Monads::Result
        def call(new_feature, container)
          updated_feature  = yield update(new_feature, container)

          Success(updated_feature)
        end

        private

        def update(new_feature, container)
          registered_feature_hash = container[new_feature.key].feature.to_h
          registered_feature_hash[:is_enabled] = new_feature.is_enabled

          registered_feature_hash[:settings] = registered_feature_hash[:settings].collect do |setting_hash|
            new_setting = new_feature.settings.detect{|setting| setting.key == setting_hash[:key]}
            setting_hash[:item] = new_setting.item if new_setting
            setting_hash
          end

          updated_feature = ResourceRegistry::Operations::Features::Create.new.call(registered_feature_hash).value!
          container.swap_feature(updated_feature)

          Success(updated_feature)
        end
      end
    end
  end
end
