require "spec_helper"
require 'dry/container/stub'

RSpec.describe ResourceRegistry::Container do

  subject { binding.pry; described_class.new  }

  it { expect(subject.config.registry).to be_a(Dry::Container::Registry) }


end