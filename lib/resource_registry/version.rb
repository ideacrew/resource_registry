# frozen_string_literal: true

module ResourceRegistry
  VERSION = "0.10.0"

  def self.stdgem_ruby_version?
    Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1.0')
  end
end
