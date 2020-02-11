# frozen_string_literal: true

require 'dry/system/container'

module ResourceRegistry
  class Configuration < Dry::Container

    attr_accessor :enabled_features

    Feature.enroll_app?



    # Features.enable     :enroll_app
    # Features.enabled?   :enroll_app # => true
    # Features.disable    :enroll_app
    # Features.disabled?  :enroll_app # => false
    # Features.enroll_app
    #   => options
    #   => parent_feature
    #   => required?
    #   => enabled?
    #   => ui_metadata
    #   => :title
    #   => :type
    #   => :default
    #   => :value
    #   => :description
    #   => :choices
    #   => :is_required
    #   => :is_visible


    def initialize
      @enabled_features = [:enroll_app, :aca_shop_market, :aca_individual_market, :fehb_market]
    end

    # end


    # # Make this an Entity
    # class ContainerConfig
    #   attr_accessor :name, :default_namespace, :root, :system_dir, :auto_register

    #   def initialize
    #     @name               = nil
    #     @root               = Pathname('./lib')
    #     @default_namespace  = nil
    #     @system_dir         = "system"
    #     @auto_register      = []

    #     self
    #     # load_paths = ('lib')
    #   end

  end

end
