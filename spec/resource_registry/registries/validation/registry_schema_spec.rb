require "spec_helper"
require 'dry/container/stub'

require 'resource_registry/types'
# require 'resource_registry/stores'
require 'resource_registry/validation/application_schema'
require 'resource_registry/registries/validation/registry_schema'

RSpec.describe ResourceRegistry::Registries::Validation::RegistrySchema do

  let(:params)  {
    {
      config: {
        name: 'name_value',  
        root: 'root_value',  
        default_namespace: 'default_namespace_value',  
        env: 'env_value',  
        system_dir: 'system_dir_value',  
        load_path: 'load_paths_value',  
        auto_register: ['auto_register_value'],
      },

      app_name: 'app_name_value',  
      timestamp: 'timestamp_value',

      persistence: {
        # store: 'store_value',  
        serializer: 'serializer_value',  
        container: 'container_value',  
      }
    }
  }

  it "validation should pass" do
    expect(subject.Schema.call(params).errors.to_h).to eq {}
  end


end
