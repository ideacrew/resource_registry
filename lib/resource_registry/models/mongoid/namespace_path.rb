# frozen_string_literal: true

module ResourceRegistry
  module Mongoid
    class NamespacePath
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :path,   type: Array
      embeds_one  :meta, class_name: '::ResourceRegistry::Mongoid::Meta'
    end
  end
end
