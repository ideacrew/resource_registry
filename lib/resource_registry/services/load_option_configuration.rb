module ResourceRegistry
  module Services
    class LoadOptionConfiguration
      attr_reader :repository

      def call(**params)
        @repository = params[:repository]
        @load_paths = params[:load_paths] || []

        register_applications

        @repository
      end

      def register_applications
        # TODO - this is entry point for loading application options
        # @repository.register
      end

    end
  end
end