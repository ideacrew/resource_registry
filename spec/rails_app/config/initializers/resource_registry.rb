# frozen_string_literal: true

require 'resource_registry'

ResourceRegistry::Application.default_store = :mongodb

ResourceRegistry.configure do |config|
  config.loader.evaluate_erb = true
  config.loader.permitted_classes = [Date, Range, Symbol, Time]
end
