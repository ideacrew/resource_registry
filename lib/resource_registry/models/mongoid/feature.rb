# frozen_string_literal: true
module ResourceRegistry
  module Mongoid
    class Feature
      include Mongoid::Document
      include Mongoid::Timestamps

      field :key,         type: Symbol
      field :namespace,   type: Array
      field :is_enabled,  type: Boolean
      field :item,        type: String

      embeds_one  :meta, class_name: 'ResourceRegistry::Mongoid::Meta'
      embeds_many :settings, class_name: 'ResourceRegistry::Mongoid::Setting'

    end
  end
end

