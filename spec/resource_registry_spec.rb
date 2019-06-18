RSpec.describe ResourceRegistry do
  it "has a version number" do
    expect(ResourceRegistry::VERSION).not_to be nil
  end

  it "generates list of symbols that match a file pattern" do
    expect(ResourceRegistry.file_kinds_for(file_pattern: '.rb', dir_base: './lib')).to include 'resource_registry.rb'  
  end

end
