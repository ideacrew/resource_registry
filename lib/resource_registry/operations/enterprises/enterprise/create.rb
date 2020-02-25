# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Enterprises
      module Enterprise
        class Create
          send(:include, Dry::Monads[:result, :do])

          def call(params)
            values = yield validate(params)
            enterprise = yield create(values)
            log(values)
            Success(enterprise)
          end

          private

          def validate(params)
            # result = ResourceRegistry::
            result = resource_registry.enterprises.validate(params)
            Success(result)
          end

          def create(values)
            enterprise = ResourceRegistry::Entities::Enterprise.new(values)
            Success(enterprise)
          end

          def log(values)
            Logger.new.info(values)
          end

        end
      end
    end
  end
end
