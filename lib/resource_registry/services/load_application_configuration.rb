module ResourceRegistry
  module Services
    class LoadApplicationConfiguration
      attr_reader :repository

      def call(params)
        @repository = params[:repository]

      end

    end
  end
end