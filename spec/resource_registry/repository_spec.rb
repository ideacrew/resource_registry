require "spec_helper"
require 'dry/container/stub'

RSpec.describe ResourceRegistry::Repository do

  describe "Instantiating a repository" do
    subject { described_class.new  }

    it { expect(subject.config.registry).to be_a(Dry::Container::Registry) }
    it "top_namespace should be nil" do
      expect(subject.top_namespace).to be_nil
    end

    context "class method #namespace_join" do
      context "is passed an empty array" do
        let(:empty_array) { [] }
        let(:joined_namespaces)   { nil }

        it { expect(subject.class.namespace_join(empty_array)).to eq joined_namespaces}
      end

      context "is passed an array with one value" do
        let(:single_value_array)  { [:level_one] }
        let(:joined_namespaces)   { 'level_one' }

        it { expect(subject.class.namespace_join(single_value_array)).to eq joined_namespaces}
      end

      context "is passed an array with > 1 value" do
        let(:multi_value_array)   { [:level_one, :level_two] }
        let(:joined_namespaces)   { 'level_one.level_two' }

        it { expect(subject.class.namespace_join(multi_value_array)).to eq joined_namespaces}
      end
    end

    context "instance method #add_namespace" do
      let(:new_namespace)     { :new_namespace }
      let(:new_namespace_str) { new_namespace.to_s }

      it { expect(subject.add_namespace(new_namespace)).to be_a(Dry::Container::Namespace)   }
      it { expect(subject.add_namespace(new_namespace).name).to eq new_namespace_str }
    end

    context "with a top namespace" do
      let(:top_namespace)     { :dchbx }
      let(:top_namespace_str) { top_namespace.to_s }

      subject { described_class.new(top_namespace: top_namespace) }
      it { expect(subject.top_namespace).to eq top_namespace_str }
    
      context "and an item is registered in the repository" do
        let(:logfile_key)   { :logfile_name}
        let(:logfile_value) { "logfile.log" }
        let(:qualified_logfile_key)  { top_namespace.to_s + '.' + logfile_key.to_s }

        before do
          namespace_str = subject.class.namespace_join([top_namespace, logfile_key])
          subject.register(namespace_str) { logfile_value }
        end

        it "the item should be found in the namespace prepended by the namespace root" do
          expect(subject.resolve(qualified_logfile_key)).to eq logfile_value
        end
      end

      context "instance method #add_namespace" do
        let(:new_namespace)   { :new_namespace }
        let(:full_namespace)  { top_namespace.to_s + '.' + new_namespace.to_s }

        it { expect(subject.add_namespace(new_namespace)).to be_a(Dry::Container::Namespace)   }
        it { expect(subject.add_namespace(new_namespace).name).to eq full_namespace }
      end
    end
  end

end

