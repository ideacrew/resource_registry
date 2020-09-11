# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Features::Update do
  include RegistryDataSeed

  subject { described_class.new.call(feature: new_params, registry: registry) }

  context 'When valid feature hash passed' do

    let(:file_io)        { ResourceRegistry::Stores::File::Read.new.call(feature_template_path).value! }
    let(:yml_params)     { ResourceRegistry::Serializers::Yaml::Deserialize.new.call(file_io).value! }
    let(:feature_params) { ResourceRegistry::Serializers::Features::Serialize.new.call(yml_params).value!.first }

    let(:registry) { ResourceRegistry::Registry.new }
    let(:feature)  { ResourceRegistry::Operations::Features::Create.new.call(feature_params).value! }

    let(:new_params) do
      {
        :key => :aca_shop_market,
        :is_enabled => true,
        :settings => [
          { enroll_prior_to_effective_on_max: { days: 10 } },
          { enroll_after_effective_on_max: { days: 60 } },
          { enroll_after_ee_roster_correction_max: { days: 60 } },
          { retro_term_max_days: { days: -120 } }
        ]
      }
    end

    before do
      registry.register_feature(feature)
    end

    it "should return success with hash output" do
      expect(registry.feature_enabled?(feature.key)).to be_falsey
      subject
      expect(registry.feature_enabled?(feature.key)).to be_truthy
    end
  end
end
