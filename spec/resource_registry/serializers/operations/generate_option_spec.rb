# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Serializers::Operations::GenerateOption do
  include RegistryDataSeed

  subject { described_class.new.call(input) }

  context 'When valid input hash passed' do

    let(:input) do
      options_hash.deep_symbolize_keys!
      options_hash
    end

    it "should return success with options object" do
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.value!).to be_a ResourceRegistry::Entities::Option
    end

    # it "should have namespaces and settings" do
    #   validate_options(subject.value!)
    # end

    # def validate_options(output)
    #   output.tap do |option|
    #     expect(option.key).to be_present
    #     if option.namespaces.present?
    #       option.namespaces.each do |namespace|
    #         expect(namespace).to be_a ResourceRegistry::Entities::Option
    #         validate_options(namespace)
    #       end
    #     end
    #     if option.settings.present?
    #       option.settings.each do |setting|
    #         expect(setting).to be_a ResourceRegistry::Entities::Setting
    #       end
    #     end
    #   end
    # end
  end
end
