# frozen_string_literal: true

require_relative 'entities/registry'
require_relative 'validation/registries/registry_contract'

require_relative 'registries/transactions/create'
require_relative 'registries/transactions/load_application_configuration'
require_relative 'registries/transactions/load_application_dependencies'
require_relative 'registries/transactions/load_dependency'
require_relative 'registries/transactions/configure'

module ResourceRegistry
  module Registries
  end
end