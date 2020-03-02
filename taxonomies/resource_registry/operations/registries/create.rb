# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Operations
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(config_file)
          container = Class.new(Dry::System::Container)
          
          file_path     = yield verify_file(config_file)
          yaml_params   = yield read_file(file_path)
          config_params = yield parse(yaml_params)
          
          config_values = yield validate(config_params)
          registry      = yield create_registry(config_values)
                        
          Success(container_constant)
        end

        private

        def verify_file(config_file)
          Success(Pathname.readable?(config_file))
        end

        def read_file(file_path)
          yaml_params = ResourceRegistry::Stores::File::Read.new.call(file_path)
          Success(yaml_params)
        end

        def parse(yaml_params)
          option_params = ResourceRegistry::Serializers::Yaml::Deserialize.new.call(yaml_params)
          Success(option_params)
        end

        def validate(option_params)
          values = ResourceRegistry::Validation::Options::OptionContact.new.call(option_params)
          Success(values)
        end

        # We need container configuration values
        # additional keys 
        # load dependencies
        # Create the container
        # Set the Injector and the Constant




      end
    end
  end
end