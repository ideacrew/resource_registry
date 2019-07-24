require "spec_helper"

RSpec.describe ResourceRegistry::CoreContainer do

  subject { described_class }

  before { binding.pry }

  it { expect(subject).to be_a(Dry::System::Container) }


end