require "spec_helper"
require 'dry/container/stub'

RSpec.describe ResourceRegistry::Options::Site do
  let(:dc_tenant)           { ResourceRegistry::Options::Tenant.new(
                                key: :dchbx, title: "DC HealthLink", 
                                application_subscription_keys: application_keys 
                                ) }
  let(:cca_tenant)          { Options::Tenant.new(
                                key: :cca, 
                                title: "Massachusettes Health Connector", 
                                application_subscription_keys: application_keys 
                                ) }

  let(:ea_app)              { Options::Application.new(
                                key: :ea_application,  
                                title: "Enroll Application application", 
                                description: "A benefits registration, eligibility and shopping system",
                                ) }

  let(:edi_db_classic_app)  { Options::Application.new(
                                key: :edi_db_classic_application, 
                                title: "EDI Database application (classic)", 
                                description: "The classic system for conducting and managing EDI transactions with trading partners",
                                ) }

  let(:edi_db_app)          { Options::Application.new(
                                key: :edi_db_application, 
                                title: "EDI Database application", 
                                description: "A system for conducting and managing EDI transactions with trading partners",
                                ) }

  let(:application_keys)    { [ea_app[:key], edi_db_classic_app[:key], edi_db_app[:key]] }

  let(:key)                 { :shared_host } 
  let(:title)               { "Multitenant shared environment" } 
  let(:applications)        { [ea_app, edi_db_classic_app, edi_db_app] } 
  let(:tenants)             { [dc_tenant, cca_tenant] } 

  let(:option_1_default)    { { logger_file_name: 'logger.log'} }
  let(:option_2_default)    { { logger_type: :file} }


  let(:params) do
    {
      key: key,
      title: title,
      applications: applications,
      tenants: tenants,
      options: []
    }
  end

  context "Instantiating the class" do
    subject { described_class.new  }

    it { binding.pry; expect(subject(params)).to be_a(Options::Site) }
  end

ResourceRegistry::Options::Site.new(
  key: :shared_host, 
  applications: [ResourceRegistry::Options::Application.new(key: :ea)], 
  tenants: [ResourceRegistry::Options::Tenant.new(ResourceRegistry::Options::Tenant.new(key: :dchbx, title: "DC HealthLink", application_subscription_keys: [1, 2]))]
  )

end