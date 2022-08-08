# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Namespaces::Build do
  include RegistryDataSeed

  subject { described_class.new.call(feature, content_types) }

  let(:registry) { ResourceRegistry::Registry.new }
  let(:features) { ResourceRegistry::Operations::Registries::Create.new.call(path: feature_template_path, registry: registry).success }

  let(:namespace_content_type) { :legend }

  let(:namespace_path) do
    {
      :path => [:features, :enroll_app],
      :meta => {
        :label => "SHOP",
        :content_type => namespace_content_type,
        :default => true,
        :is_required => false,
        :is_visible => true
      }
    }
  end

  let(:feature_meta) do
    {
      :label => "Enable ACA SHOP Market",
      :content_type => :boolean,
      :default => true,
      :is_required => false,
      :is_visible => true
    }
  end

  let(:feature) do
    ResourceRegistry::Feature.new({
                                    :key => :employer_sic,
                                    :namespace_path => namespace_path,
                                    :is_enabled => false,
                                    :meta => feature_meta
                                  })
  end

  context 'When feature with missing meta passed' do
    let(:content_types) { nil }
    let(:feature_meta) { {} }

    it 'should fail with error' do
      result = subject

      expect(result).to be_a Dry::Monads::Result::Failure
      expect(result.failure).to include("feature meta can't be empty")
    end
  end

  context 'When namespace content_types argument passed' do
    let(:content_types) { %w[feature_list nav] }

    context 'and feature namespace content_type mismatched' do
      let(:namespace_content_type) {:legend}

      it 'should fail with error' do
        result = subject

        expect(result).to be_a Dry::Monads::Result::Failure
        expect(result.failure).to include("namesapce content type should be #{content_types}")
      end
    end

    context 'and feature namespace content_type matched' do
      let(:namespace_content_type) {:nav}

      it 'should pass and return namespace' do
        result = subject

        expect(result).to be_a Dry::Monads::Result::Success
        output = result.success
        expect(output[:path]).to eq(feature.namespace_path.path)
        expect(output[:feature_keys]).to include(feature.key)
      end
    end
  end

  context 'When namespace content_types argument not passed' do
    let(:content_types) { nil }

    context 'and feature has meta and namespace_path' do
      it 'should pass and return namespace' do
        result = subject

        expect(result).to be_a Dry::Monads::Result::Success
        output = result.success
        expect(output[:path]).to eq(feature.namespace_path.path)
        expect(output[:feature_keys]).to include(feature.key)
      end
    end
  end
end