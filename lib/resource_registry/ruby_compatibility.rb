# frozen_string_literal: true

module ResourceRegistry
  class RubyCompatibility
    def self.load_standard_gems_if_needed
      load_standard_gems if ResourceRegistry.stdgem_ruby_version?
    end

    def self.load_standard_gems
      require 'bigdecimal'
      require 'ostruct'
    end
  end
end

ResourceRegistry::RubyCompatibility.load_standard_gems_if_needed
