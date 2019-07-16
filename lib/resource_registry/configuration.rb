module ResourceRegistry
  class Configuration
    extend Dry::Configurable

    setting :store
    setting :parser
    setting :auto_load_path
    setting :top_namespace

    # attr_accessor :configuration

    # def load!(application)
    #   @configuration = Dry::Container::new
    #   @configuration.namespace(application.key) do |ns|
    #     application.features.each do |feature|
    #       _load(ns, feature)
    #     end
    #   end
    # end

    # def _load(ns, model)
    #   if model.options.present?
    #     ns.namespace(key) do |option_ns|
    #       model.options.each {|option| _load(option_ns, option) }
    #     end
    #   else
    #     ns.register(key, default) if model.respond_to?(:default)
    #   end
    # end
  end
end