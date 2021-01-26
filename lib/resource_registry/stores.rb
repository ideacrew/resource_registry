# frozen_string_literal: true

require_relative 'stores/file/read'
require_relative 'stores/file/list_path'
require_relative 'stores/container/update'
require_relative 'stores/mongoid/find'
require_relative 'stores/mongoid/persist'
require_relative 'stores/active_record/find'
require_relative 'stores/active_record/update'


module ResourceRegistry
  module Stores
    class << self

      def persist(entity, registry, params = {})
        return unless store_namespace

        "#{store_namespace}::Persist".constantize.new.call(entity, registry, params)
      end

      def find(feature_key)
        return unless store_namespace

        "#{store_namespace}::Find".constantize.new.call(feature_key)
      end

      def store_namespace
        "ResourceRegistry::Stores::#{orm}".constantize if orm
      end

      def feature_model
        "ResourceRegistry::#{orm}::Feature".constantize if orm
      end

      def orm
        if defined? ResourceRegistry::Mongoid
          'Mongoid'
        elsif defined? ResourceRegistry::ActiveRecord
          'ActiveRecord'
        end
      end
    end
  end
end