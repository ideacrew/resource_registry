# frozen_string_literal: true
module ResourceRegistry
  module Mongoid
    class Setting
      include Mongoid::Document
      include Mongoid::Timestamps

      field :key,         type: Symbol
      field :options,     type: Array
      field :item,        type: String

      embeds_one :meta, class_name: 'ResourceRegistry::Mongoid::Meta'

    end
  end
end
