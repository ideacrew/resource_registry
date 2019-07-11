module ResourceRegistry
  module Services
    class InitializeApplicationRepository
      # AutoInject makes `load_boot_configuration` and `load_application_configuration` available to use
      include Services::Import["load_boot_configuration", "load_application_configuration"]

      def call(params)
        # Path patterns to auto-import
        @load_paths = params[:load_paths] || []

        result = load_boot_configuration.call(params)

        if result.success?
          load_application_configuration.call(params)
        else
          # FIXME Application boot configuration load failed - shut down!!
        end
      end
    end
  end
end
