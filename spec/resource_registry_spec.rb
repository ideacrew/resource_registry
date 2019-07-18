RSpec.describe ResourceRegistry do
  it "has a version number" do
    expect(ResourceRegistry::VERSION).not_to be nil
  end

  let(:matched_file_token)   { :resource_registry }

  it "generates list of symbols that match a file pattern" do
    expect(ResourceRegistry.file_kinds_for(file_pattern: '*.rb', dir_base: './lib')).to include matched_file_token  
  end

  it { should be_const_defined(:INFLECTOR) }
  it { should be_const_defined(:OPTIONS_REPOSITORY) }
  it { should be_const_defined(:OPTIONS_AUTO_INJECT) }

end
