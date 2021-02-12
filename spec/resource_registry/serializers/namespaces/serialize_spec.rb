# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Serializers::Namespaces::Serialize do
  include RegistryDataSeed

  subject { described_class.new.call(features: features, namespace_types: namespace_types) }

  context 'When features set passed' do

    let(:registry) { ResourceRegistry::Registry.new }
    let(:features) { ResourceRegistry::Operations::Registries::Create.new.call(path: feature_group_template_path, registry: registry).success }
    let(:features_with_meta) { features.select{|f| f.meta.to_h.present?} }
    
    context "when namespace_types ignored" do
      let(:namespace_types) { [] }

      it "should return namespace hash with meta defined features" do
        result = subject.success

        expect(subject).to be_a Dry::Monads::Result::Success
        features_with_meta.each do |feature|
          namespace_key = feature.namespace_path.path.map(&:to_s).join('_')
          namespace_hash = result.detect{|values| values[:key] == namespace_key}
          expect(namespace_hash).to be_present
          expect(namespace_hash[:feature_keys]).to include(feature.key)
        end
      end
    end

    context "when namespace_types passed" do
      let(:namespace_types) { %w[feature_list nav] }

      it "should return namespace hash with meta defined and namespace_type matching features" do
        result = subject.success
        expected_features = features_with_meta.select{|feature| namespace_types.include?(feature.namespace_path&.meta&.content_type&.to_s)}

        expect(subject).to be_a Dry::Monads::Result::Success
        expected_features.each do |feature|
          namespace_key = feature.namespace_path.path.map(&:to_s).join('_')
          namespace_hash = result.detect{|values| values[:key] == namespace_key}
          expect(namespace_hash).to be_present
          expect(namespace_hash[:feature_keys]).to include(feature.key)
        end
      end
    end
  end
end