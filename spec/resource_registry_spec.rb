RSpec.describe ResourceRegistry do
  it "has a version number" do
    expect(ResourceRegistry::VERSION).not_to be nil
  end

  let(:file_symbol)   { :resource_registry }
  it "generates list of symbols that match a file pattern" do
    expect(ResourceRegistry.file_kinds_for(file_pattern: '*.rb', dir_base: './lib')).to include file_symbol  
  end

end
