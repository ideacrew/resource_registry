require "spec_helper"
# require 'dry/container/stub'

RSpec.describe ResourceRegistry::Services::CreateOptionsRepository do

  subject { described_class }

  describe "Instantiating a repository" do
    let(:options_top_namespace)  { "options_repository" }

    it "should return an option repository instance" do
      expect(subject.call).to be_a ResourceRegistry::Repository
      expect(subject.call.top_namespace).to eq options_top_namespace
    end
  end


end
