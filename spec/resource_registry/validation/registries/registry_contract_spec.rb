# frozen_string_literal: true

require "spec_helper"

RSpec.describe ResourceRegistry::Validation::Registries::RegistryContract do

  let(:top_parms) do
    {
      app_name: 'app_name_value',
      timestamp: 'timestamp_value'
    }
  end

  let(:config_parms) do
    {
      config: {
        name: 'name_value',
        root: Pathname.pwd,
        default_namespace: 'default_namespace_value',
        env: 'development',
        system_dir: 'system_dir_value',
        load_path: 'load_path_value',
        auto_register: ['auto_register_value']
      }
    }
  end

  let(:persistence_parms) do
    {
      persistence: {
        store: 'file_store',
        serializer: 'yaml_serializer',
        container: 'container_value'
      }
    }
  end


  context "with valid params" do
    let(:valid_parms)       { top_parms.merge(config_parms.merge(persistence_parms)) }

    it "validation should pass" do
      expect(subject.new.call(valid_parms).errors.to_h).to eq Hash.new
    end

    it "returns data in specified format" do
      expect(valid_parms).to match_schema(subject)
    end
  end

  context "with an invalid pathname" do
    let(:invalid_pathname)  { { config: { root: Pathname('sillypathname') } } }
    let(:pathname_error)    { ["pathname not found: sillypathname"] }

    it "validation should fail" do
      expect(subject.new.call(invalid_pathname).errors.to_h[:config][:root]).to eq pathname_error
    end

    it "returns data in specified format" do
      expect(invalid_pathname).not_to match_schema(subject)
      # expect((invalid_pathname).errors).to_not match_schema(subject)
    end
  end


end
