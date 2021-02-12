# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Graphs::Create do
  include RegistryDataSeed

  subject { described_class.new.call(namespaces, registry) }

  let(:registry) { ResourceRegistry::Registry.new }
  let(:features) { ResourceRegistry::Operations::Registries::Create.new.call(path: feature_group_template_path, registry: registry).success }
  let(:namespace_types) { %w[feature_list nav] }
  let(:namespaces) { ResourceRegistry::Serializers::Namespaces::Serialize.new.call(features: features, namespace_types: namespace_types).success }
  let(:features_with_meta) { features.select{|f| f.meta.to_h.present?} }  
  let(:matched_features) { features_with_meta.select{|feature| namespace_types.include?(feature.namespace_path&.meta&.content_type&.to_s)} }

  context 'When a valid namespace passed' do

    it 'should return success monad' do
      expect(subject).to be_a Dry::Monads::Result::Success
    end

    it 'should return a directed acyclic graph' do
      value = subject.success
      expect(value).to be_a RGL::DirectedAdjacencyGraph
      expect(value.directed?).to be_truthy
      expect(value.cycles).to be_empty
    end

    it 'should create vertices with valid namespace paths' do
      graph = subject.success
      namespace_paths = matched_features.collect{|feature| feature.namespace_path.path}.uniq

      namespace_paths.inject([]){|vertex_paths, path| vertex_paths += path_to_vertex_path(path)}.uniq.each do |vertex_path|
        vertex = graph.vertices.detect{|vertex| vertex.path == vertex_path}
        expect(vertex).to be_present
      end
    end
  end

  def path_to_vertex_path(path = [])
    return if path.empty?
    paths = []
    vertex_paths = []
    while true
      current = path.shift
      paths.push(current)
      vertex_paths << paths.dup
      break if path.empty?
    end
    vertex_paths
  end

  context 'When invalid namespaces passed' do
    let(:feature1) {
      ResourceRegistry::Feature.new({
        :key => :health_packages,
        :namespace_path => {
          :path => [:dchbx, :enroll_app, :aca_shop_market],
          :meta => {
            :label => "ACA Shop",
            :content_type => :feature_list,
            :is_required => true,
            :is_visible => true
          }
        },
        :is_enabled => true,
        :item => :features_display,
        :meta => {
          :label => "Health Packages",
          :content_type => :legend,
          :is_required => true,
          :is_visible => true
        },
      })
    }
    
    let(:feature2) {
      ResourceRegistry::Feature.new({
        :key => :health_packages_two,
        :namespace_path => {
          :path => [:aca_shop_market, :dchbx, :enroll_app],
          :meta => {
            :label => "ACA Shop",
            :content_type => :feature_list,
            :is_required => true,
            :is_visible => true
          }
        },
        :is_enabled => true,
        :item => :features_display,
        :meta => {
          :label => "Health Packages",
          :content_type => :legend,
          :is_required => true,
          :is_visible => true
        },
      })
    }

    let(:features) { [feature1, feature2] }
    
    # Pending
    it 'should return with error' do
      subject
    end
  end
end