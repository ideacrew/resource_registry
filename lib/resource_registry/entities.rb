# frozen_string_literal: true

require 'dry-struct' unless defined?(Dry::Struct)
require 'dry-initializer'



module ResourceRegistry
  module Entities
    # rubocop:disable Style/RescueModifier
    # RegistryConstructor = Types.Constructor('Registry') { |val| Registry.new(val) rescue nil }
    # rubocop:enable Style/RescueModifier
  end
end