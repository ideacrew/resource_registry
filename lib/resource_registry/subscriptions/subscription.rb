module ResourceRegistry
  module Subscriptions
    class Tenant
      # include Mongoid::Document
      # include Mongoid::Timestamps

      # has_many  :subscriptions,
      #   class_name: 'Subscriptions::Subscription'

      # field :site_key, type: Symbol
      # field :name, type: String

      # validates_presence_of :site_key, :name
      # index({ site_key: 1 }, { unique: true })

      def features
        Subscriptions::Feature.in(id: subscriptions.pluck(:feature_id))
      end

    end
  end
end
