# frozen_string_literal: true

module ResourceRegistry
  module Mongoid
    class Meta
      include Mongoid::Document
      include Mongoid::Timestamps

      field :label,         type: String
      field :type,          type: Symbol
      field :default,       type: String
      field :value,         type: String
      field :description,   type: String
      field :enum,          type: Array
      field :is_required,   type: Boolean
      field :is_visible,    type: Boolean
      # :release — temporary rollout gate; clean up once enabled for all clients.
      # :configuration — permanent per-client toggle; both paths always needed.
      field :flag_type,     type: Symbol

    end
  end
end
