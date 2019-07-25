RSpec.describe ResourceRegistry do
  it "has a version number" do
    expect(ResourceRegistry::VERSION).not_to be nil
  end

  let(:matched_file_token)   { :resource_registry }

end
