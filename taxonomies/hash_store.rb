# frozen_string_literal: true
require 'deep_merge'

module ResourceRegistry
  module Stores
    module Operations
      class HashStore

        include Dry::Transaction::Operation

        def call(input)
          if defined? ResourceRegistry::AppSettings
            DeepMerge.deep_merge!(
              input.to_h,
              ResourceRegistry::AppSettings,
              merge_hash_arrays: true,
              merge_nil_values:  true,
            )
          else
            ResourceRegistry.const_set('AppSettings', input.to_h)
          end

          Success(input)
        end
      end
    end
  end
end