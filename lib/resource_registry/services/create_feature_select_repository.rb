module ResourceRegistry
  module Services
    class CreateFeatureSelectRepository
      include ResourceRegistry::Service

      # Provide helpers for registering and accessing repository-based dependency injection
      FEATURE_SELECT_AUTO_INJECT = Dry::AutoInject(@repository)

      attr_reader :repository

      def call(params)
        @load_paths = params[:load_paths] || []

        repository
      end
      
      def repository
        @repository ||= CreateRepository(top_namespace: :feature_select_repository)
      end

    end
  end
end