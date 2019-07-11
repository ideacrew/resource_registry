# Instantiate a container 
require "dry-auto_inject"

module ResourceRegistry
  module Services
    class CreateRepository
      Import = Dry::AutoInject(self)

      attr_reader :repository

      def initialize(args)
        @repository_name  = args[:repository_name] || 'Repo'
        @repository = build_repository


        register_repository_kinds
        @repository
      end

      def build_repository
        Object.const_set(@repository_name.classify, ResourceRegistry::Repository.new)
      end

      # Repository is like a human stem cell, it includes instructions that enable it to specialize to serve any purpose
      def register_repository_kinds
        @repository.register "initialize_application_repository",   -> { ResourceRegistry::Services::InitializeApplicationRepository.new }
        @repository.register "load_application_boot_configuration", -> { ResourceRegistry::Services::LoadApplicationBootConfiguration.new }
        @repository.register "load_application_configuration",      -> { ResourceRegistry::Services::LoadApplicationConfiguration.new }

        @repository.register "initialize_feature_check_repository", -> { ResourceRegistry::Services::InitializeFeatureCheckRepository.new }
      end

    end
  end
end