require "spec_helper"
require 'dry/container/stub'

require 'resource_registry/types'
require 'resource_registry/entities'
# require 'resource_registry/registries/registry'
# require 'resource_registry/stores'
require 'resource_registry/validation/application_contract'
require 'resource_registry/registries/validation/registry_contract'

RSpec.describe ResourceRegistry::Registries::Validation::RegistryContract do

  subject { described_class.new }

  let(:top_parms) {
    {
      app_name: 'app_name_value',  
      timestamp: 'timestamp_value',
    }
  }

  let(:config_parms)  {
    {
      config: {
        name: 'name_value',  
        root: Pathname.pwd,  
        default_namespace: 'default_namespace_value',  
        env: 'development',  
        system_dir: 'system_dir_value',  
        load_path: 'load_path_value',  
        auto_register: ['auto_register_value'],
      }
    }
  }

  let(:persistence_parms) {
    {
      persistence: {
        store: 'file_store',  
        serializer: 'yaml_serializer',  
        container: 'container_value',        }
    }
  }


  context "with a valid pathname" do
    let(:valid_parms)     { top_parms.merge(config_parms.merge(persistence_parms)) }

    it "validation should pass" do
      expect(subject.call(valid_parms).errors.to_h).to eq Hash.new
    end
  end

  context "with a bad pathname" do
    let(:bad_pathname)    { { config: { root: Pathname('sillypathname') } } }
    let(:pathname_error)  { ["pathname must exist"] }

    it "validation should fail" do
      expect(subject.call(bad_pathname).errors.to_h[:config][:root]).to eq pathname_error
    end
  end






end
