require "./spec/spec_helper"

RSpec.describe 'Enroll App' do
  describe 'Load Settings' do
    it { expect(require './spec/rails_app/db/seedfiles/enroll_app/load_settings').to be_truthy }
  end
end