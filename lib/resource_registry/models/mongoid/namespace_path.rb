# frozen_string_literal: true

module ResourceRegistry
  module Mongoid
    class NamespacePath
      include ::Mongoid::Document
      include ::Mongoid::Timestamps

      field :path,   type: Array

      embeds_one :meta, as: :metable, class_name: '::ResourceRegistry::Mongoid::Meta', cascade_callbacks: true
      embedded_in :feature, class_name: '::ResourceRegistry::Mongoid::Feature'
    end
  end
end
