# frozen_string_literal: true

require 'pathname'

module ResourceRegistry
  module Operations
    module Options
      class Load
        send(:include, Dry::Monads[:result, :do])

        def call(file_params)
          file_path     = yield verify_file(file_params)
          yaml_params   = yield read_file(file_path)
          option_params = yield parse(yaml_params)
          values        = validate(option_params)

          Success(values)
        end

        private

        def verify_file(file_params)
          Success(Pathname.readable?(file_params))
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

        private

        def validate(input)
          result = super

          if result.success?
            Success(result)
          else
            Failure(result.errors)
          end
        end
      end
    end
  end
end
