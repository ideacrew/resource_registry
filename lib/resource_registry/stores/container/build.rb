# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Container
      # Instantiate a new Dry::Container object
      class Build
        send(:include, Dry::Monads[:result, :do])

        # @param [ResourceRegistry::Entities::Registry] params configuration option values for the container
        # @return [Dry::Container] A non-finalized Dry::Container with associated configuration values wrapped in Dry::Monads::Result
        def call(params = {})
          container             = yield create_container.value!
          configured_container  = yield configure(container, params)

          Success(configured_container)
        end

        private

        def create_container
          Success(Dry::Container.new)
        end

        def configure(container, params)
          params[:config].each_pair do |_key, value|
            container.config[:key] = value
          end

          Success(container)
        end

        ## This should be rule definition in the Contract
        # def transform_root_to_path(params)
        #   params[:config][:root] = Pathname.new(params[:config][:root]) if params[:config] && params[:config][:root] && !params[:config][:root].is_a?(Pathname)
        #   params
        # end

      end
    end
  end
end
