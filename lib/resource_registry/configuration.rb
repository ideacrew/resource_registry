module ResourceRegistry
  class Configuration
    attr_reader :repository, :load_paths

    def call(params)
      @repository_name = params[:repository_name] || 'Repo'
      @load_paths = params[:load_paths] || []

      @repository = create_repository

    end

    def create_repository
      Object.const_set(@repository_name.classify, ResourceRegistry::Repository.new)
    end

    def initialize_site
    end

    def initialize_applications
    end

    # Reload and replace all settings using system default values
    def reset!
    end



  end
end