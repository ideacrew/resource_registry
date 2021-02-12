# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Features::Renew do
  include RegistryDataSeed

  subject { described_class.new.call(params) }

  context 'When valid feature hash passed' do

    let(:registry) { ResourceRegistry::Registry.new }
    let!(:register) { ResourceRegistry::Operations::Registries::Create.new.call(path: feature_group_template_path, registry: registry) }

    let(:params) do
      {
        params: {
          target_feature: 'health_product_package_2021',
          settings: {calender_year: "2022"}
        },
        registry: registry
      }
    end

    it "should return success with hash output" do
      stub_const("EnrollRegistry", registry)

      expect(subject).to be_a Dry::Monads::Result::Success
      expect(registry[:health_product_package_2022]).to be_truthy
    end
  end
end