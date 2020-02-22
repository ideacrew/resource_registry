# frozen_string_literal: true

module ResourceRegistry
  module Validation
    module Settings
      class SettingContract < ResourceRegistry::Validation::ApplicationContract

        params do
          required(:key).value(:symbol)
          optional(:value).maybe(:any)
          optional(:meta).maybe(:hash)
        end

        # rule([:settings, :options]) do
        #   if key? && value

        #     value.each do |var|
        #       result = OptionContract.new.call({:key => var[:key], :value => var[:value]})
        #       key.failure(text: "invalid namespace", error: result.errors.to_h) if result && result.failure?
        #     end

        #   end
        # end

      end
    end
  end
end
