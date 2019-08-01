require "spec_helper"
require 'dry/container/stub'
require 'resource_registry/services/service'
require 'resource_registry/serializers/option_generate'
require 'resource_registry/entities'

RSpec.describe ResourceRegistry::Serializers::OptionGenerate do
skip "TODO Verify and update the spec" do
let(:valid_option_hash)   {

                      { namespace: { key: :namespace_level_one_first,
                                     settings: [{ key: :option_level_1_1,
                                                  title: 'this is title',
                                                  description: 'description_1',
                                                  type: :integer,
                                                  value: 100,
                                                  default: 1 },
                                                { key: :option_level_1_2,
                                                  title: 'this is title',
                                                  description: 'description_2',
                                                  type: :array,
                                                  value: %i[item_1 item_2 item_3 item_4],
                                                  default: %i[item_0 item_1 item_2 item_3 item_4 item_5] }],
                                     namespaces: [{ key: :namespace_level_two,
                                                    settings: [{ key: :option_level_2_1,
                                                                 title: 'this is title',
                                                                 description: nil,
                                                                 type: :string,
                                                                 value: 'value',
                                                                 default: 'default_6' },
                                                               { key: :option_level_2_2,
                                                                 type: :float,
                                                                 value: 3.14,
                                                                 title: 'this is title',
                                                                 description: nil,
                                                                 default: 3.14 }],
                                                    namespaces: [{ key: :namespace_level_three,
                                                                   settings: [{ key: :option_level_3_1,
                                                                                title: 'this is title',
                                                                                description: nil,
                                                                                type: :boolean,
                                                                                value: true,
                                                                                default: true },
                                                                              { key: :option_level_3_2,
                                                                                title: 'this is title',
                                                                                description: nil,
                                                                                type: :duration,
                                                                                value: { 'unit' => 'month', 'count' => 2 },
                                                                                default: { 'unit' => 'month', 'count' => 3 } },
                                                                              { key: :option_level_3_3,
                                                                                title: 'this is title',
                                                                                description: nil,
                                                                                type: :float,
                                                                                value: '{{ 3 / 4 }}',
                                                                                default: '{{ 3 / 4 }}' }] }] }] } }

                    }


    context "with a valid option hash" do

      it "should generate an Option struct" do
        expect(subject.call(valid_option_hash)).to be_a(ResourceRegistry::Entities::Option)
      end


    end
end
end