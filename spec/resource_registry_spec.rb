RSpec.describe ResourceRegistry do
  it "has a version number" do
    expect(ResourceRegistry::VERSION).not_to be nil
  end

  let(:matched_file_token)   { :resource_registry }

  it "generates list of symbols that match a file pattern" do
    expect(ResourceRegistry.file_kinds_for(file_pattern: '*.rb', dir_base: './lib')).to include matched_file_token  
  end

  it { should be_const_defined(:INFLECTOR) }

  context "Options Repository Constant" do
    let(:options_top_namespace)  { "options_repository" }

    it { should be_const_defined(:OPTIONS_REPOSITORY) }

    it "should be an option repository instance" do
      expect(ResourceRegistry::OPTIONS_REPOSITORY).to be_a ResourceRegistry::Repository
      expect(ResourceRegistry::OPTIONS_REPOSITORY.top_namespace).to eq options_top_namespace
    end


    context "Auto Injection Constant" do
      it { should be_const_defined(:OPTIONS_AUTO_INJECT) }

      it "should be an options repository auto injection instance" do
        expect(ResourceRegistry::OPTIONS_AUTO_INJECT.container.top_namespace).to eq options_top_namespace
      end

      context "When an injection class is registered" do
        let(:proc_key)          { 'greeting_proc' }
        let(:greeting_string)   { "hello world!"}
        let(:greeting_proc)     { ->{ greeting_string } }

        before do 
          ResourceRegistry::OPTIONS_REPOSITORY.register(proc_key, greeting_proc)

          class InjectionKlass
            include ResourceRegistry::OPTIONS_AUTO_INJECT['greeting_proc']
            def call
              greeting_proc
            end
          end         

        end

        it "auto inject should resolve registered key" do
          expect(InjectionKlass.new.call).to eq greeting_string
        end
      end
    end
  end



end
