# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Namespaces::ListFeatures do
  include RegistryDataSeed

  subject { described_class.new.call(params) }

  context 'When valid feature hash passed' do

    let(:registry) { ResourceRegistry::Registry.new }
    let(:register)  { ResourceRegistry::Operations::Registries::Create.new.call(path: feature_group_template_path, registry: registry) }
    let(:namespace) {"enroll_app.aca_shop_market.benefit_market_catalog.catalog_2021.contribution_model_criteria"}
    let(:params)    { {namespace: namespace, registry: 'EnrollRegistry'} }

    before { register }

    it "should return success with features" do
      stub_const("EnrollRegistry", registry)

      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.success.map(&:key)).to eq registry.features_by_namespace(namespace)
    end
  end
end