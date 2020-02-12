# frozen_string_literal: true

puts 'in ResourceRegistry::Enterprises!!!'

require_relative 'validation/enterprises/enterprise_contract'
require_relative 'entities/enterprise'
require_relative 'operations/enterprises/create'

module ResourceRegistry
  module Enterprises
  end
end