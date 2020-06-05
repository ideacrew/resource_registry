# frozen_string_literal: true

require 'spec_helper'
require 'resource_registry/entities/registry'

RSpec.describe ResourceRegistry::Entities::Registry do

  subject { described_class.new(params) }

  context 'when valid registry hash passed' do
    let(:params) {
      {
        config: {
          name: "EdiApp",
          default_namespace: "options",
          root: Pathname.pwd.join('spec', 'rails_app'),
          system_dir: "system",
          auto_register: []
        },
        load_paths: ['system']
      }
    }

    it 'should build registry object' do
      expect(subject).to be_instance_of(described_class)
    end
  end
end