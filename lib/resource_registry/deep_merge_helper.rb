# frozen_string_literal: true

if defined?(Rails::VERSION) && Rails::VERSION::MAJOR >= 7
  require 'deep_merge/rails_compat'
else
  require 'deep_merge'
end

module ResourceRegistry
  # The `ResourceRegistry::DeepMergeHelper` module serves as a namespace for helper methods used across the ResourceRegistry gem.
  # These methods provide utility functions that are used by the other modules and classes in the gem.
  module DeepMergeHelper
    def self.rails_7_1_or_higher?
      defined?(Rails) && Rails::VERSION::MAJOR >= 7
    end

    def self.deep_merge_to_hash(target_hash, value, options = {})
      if rails_7_1_or_higher?
        target_hash.deeper_merge!(value, options)
      else
        target_hash.deep_merge!(value, options)
      end

      target_hash
    end
  end
end
