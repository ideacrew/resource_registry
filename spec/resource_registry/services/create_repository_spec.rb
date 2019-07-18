require "spec_helper"
# require 'dry/container/stub'

RSpec.describe ResourceRegistry::Services::CreateRepository do

  subject { described_class }

  describe "Instantiating a repository" do
    let(:default_top_namespace) { "resource_repository" }

    it "should return a repository instance" do
      expect(subject.call).to be_a ResourceRegistry::Repository
    end

    it "the top namespace should be default value" do
      expect(subject.call.top_namespace).to eq default_top_namespace
    end

    context "and a top_namespace is provided" do
      let(:top_namespace) { "my_application_repo" }

      it "the top namespace should be the passed value" do
        expect(subject.new.call(top_namespace: top_namespace).top_namespace).to eq top_namespace
      end
    end

  end
end