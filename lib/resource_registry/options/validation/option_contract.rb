require 'dry/validation'
require File.expand_path(File.join(File.dirname(__FILE__), "setting_contract"))

module ResourceRegistry
  module Options
    module Validation
      unless defined?(MAX_OPTION_DEPTH)
        MAX_OPTION_DEPTH = 15
      end

      class BottomNamespaceContract < ResourceRegistry::Validation::ApplicationContract
        params do
          required(:key).filled(Dry::Types["string"] | Dry::Types["symbol"])
          optional(:settings).array(SettingContract.__schema__)
        end
      end

      eval <<-RUBYCODE
      class NamespaceLevel#{MAX_OPTION_DEPTH}Contract < ResourceRegistry::Validation::ApplicationContract
        params do
          required(:key).filled(Dry::Types["string"] | Dry::Types["symbol"])
          optional(:settings).array(SettingContract.__schema__)
          optional(:namespaces).array(BottomNamespaceContract.__schema__)
        end
      end
      RUBYCODE

      (1..(MAX_OPTION_DEPTH - 1)).to_a.reverse.each do |i|
      eval(<<-RUBYCODE)
      class NamespaceLevel#{i}Contract < ResourceRegistry::Validation::ApplicationContract
        params do
          required(:key).filled(Dry::Types["string"] | Dry::Types["symbol"])
          optional(:settings).array(SettingContract.__schema__)
          optional(:namespaces).array(NamespaceLevel#{i + 1}Contract.__schema__)
        end
      end
      RUBYCODE
      end

      class OptionContract < ResourceRegistry::Validation::ApplicationContract
        params do
          required(:key).filled(Dry::Types["string"] | Dry::Types["symbol"])
          optional(:settings).array(SettingContract.__schema__)
          optional(:namespaces).array(NamespaceLevel1Contract.__schema__)
        end
      end
    end
  end
end