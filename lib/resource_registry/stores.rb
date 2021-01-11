# frozen_string_literal: true

require_relative 'stores/file/read'
require_relative 'stores/file/list_path'
require_relative 'stores/container/update'
require_relative 'stores/mongoid/persist'
require_relative 'stores/active_record/update'


module ResourceRegistry
  module Stores

	def self.persist(entity)
      if defined?(ResourceRegistry::Mongoid)
        ResourceRegistry::Stores::Mongoid::Persist.new.call(entity)
      elsif defined? ResourceRegistry::ActiveRecord
        ResourceRegistry::Stores::ActiveRecord::Persist.new.call(entity)
      end
    end
  end
end
