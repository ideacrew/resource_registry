# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Namespaces::UpdateFeatures do
  include RegistryDataSeed

  subject { described_class.new.call(namespace: params, registry: registry) }

  context 'When valid feature hash passed' do

    let(:registry) do
      registry = ResourceRegistry::Registry.new
      registry.register('configuration.load_path', features_folder_path)
      registry
    end

    before do
      ResourceRegistry::Operations::Registries::Load.new.call(registry: registry)
    end

    let(:params) do
      {
        features: {
          :"0" => {key: 'health', is_enabled: 'true', namespace: 'shop.2021'},
          :"1" => {key: 'dental', is_enabled: 'true', namespace: 'shop.2021'},
          :"2" => {
            key: 'benefit_market_catalog',
            namespace: 'shop.2021',
            is_enabled: 'true',
            settings: {
              :"0" => {title: "DC Health Link SHOP Benefit Catalog"},
              :"1" => {description: "Test Description"}
            }
          }
        }
      }
    end

    it "should return success with hash output" do
      subject
    end
  end
end
