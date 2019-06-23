RSpec.shared_examples 'a feature repository' do
  describe 'benefit_sponsors' do
    describe 'features' do
      subject { binding.pry; BenefitSponsors::Features::FeatureRepository.new }
      it { expect(subject).to be_a(Dry::Container) }
    end
  end
end