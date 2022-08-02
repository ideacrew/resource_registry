# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Determine if a user is authorized to perform an action
      class Authorize
        send(:include, Dry::Monads[:result, :do])

        # @param [String] account The authenticated account requesting access
        # @param [Array<Symbol>] domain The Feature that is subject of access request
        #
        # @example Request access to SHOP SupergroupID Feature
        #
        # @return [Boolean] authorized Determination whether User has priviliges to access Feature
        def call(_account, _domain)
          result = yield verify(params)
          Success(result)
        end

        private

        def verify(params); end

      end
    end
  end
end
