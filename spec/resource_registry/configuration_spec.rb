# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Configuration do

  describe "container" do

    let(:name)              { "EdiApp" }
    let(:default_namespace) { "options" }
    let(:root)              { Pathname.pwd.join('spec', 'rails_app') }
    let(:system_dir)        { "system" }
    let(:auto_register)     { [] }


    it "will initialize settings container"


    it "resets the configuration" do
      # ResourceRegistry.reset
      # config = ResourceRegistry.configuration
      # expect(config.xxx).to eq("")
    end
  end


end
