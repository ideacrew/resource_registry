module ResourceRegistry
  module Services
    class CreateRepository
      include ResourceRegistry::Services::Service
      # include ResourceRegistry::Config['top_namespace'] if defined? ResourceRegistry::Config

      def call(**params)
        @top_namespace = params[:top_namespace] || :resource_repository

        execute
      end

      private

      def execute
        ResourceRegistry::Repository.new(top_namespace: @top_namespace)
      end
    end
  end
end