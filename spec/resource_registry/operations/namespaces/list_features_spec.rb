# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Namespaces::ListFeatures do
  include RegistryDataSeed

  subject { described_class.new.call(params) }

  context 'When valid feature hash passed' do

    let!(:registry) { ResourceRegistry::Registry.new }
    let(:register) { ResourceRegistry::Operations::Registries::Create.new.call(path: feature_group_template_path, registry: registry) }

    let!(:test_registry) do
      register
      ::ResourceRegistry::TestRegistry = registry
    end

    let(:namespace) {"enroll_app.aca_shop_market.benefit_market_catalog.catalog_2021.contribution_model_criteria"}

    let(:params) {
      {namespace: namespace, registry: 'ResourceRegistry::TestRegistry'}
    }

    it "should return success with hash output" do
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.success).to eq registry.features_by_namespace(namespace)
    end
  end
end