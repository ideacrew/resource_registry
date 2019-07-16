require 'yaml'

module ResourceRegistry
  module Stores
    module Serializers
      class YamlSerializer

        def initialize(path)
          @path = path.to_s
        end

        def load
          result = YAML.load(ERB.new(IO.read(@path)).result) if @path and File.exist?(@path)
          result || {}
        rescue Psych::SyntaxError => e
          raise "YAML syntax error occurred while parsing #{@path}. " \
          "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
          "Error: #{e.message}"
        end

        alias :load! :load

        class << self
          def generate(object)
          end

          def parse
            configurations = {}
            glob_pattern = File.join(ResourceRegistry.root, 'spec', 'db', 'seedfiles', 'dc', "aca_shop_market.yml")
            
            Dir.glob(glob_pattern).each { |path|
              setting_hash = YAML.load(ERB.new(IO.read(path)).result)
              if setting_hash.empty?
                configurations = setting_hash
              end
              DeepMerge.deep_merge!(setting_hash, configurations)
            }
            __convert(result: configurations['namespace'])
          rescue Psych::SyntaxError => e
            # raise "YAML syntax error occurred while parsing #{@path}. " \
            # "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            # "Error: #{e.message}"
          end

          def __convert(result: nil, parent_ele: nil)
            result.symbolize_keys!

            if result.keys.include?(:namespaces) || result.keys.include?(:settings)
              options = ResourceRegistry::Options.new(key: result[:key].to_sym)
              root = options if parent_ele.blank?
              parent_ele.namespaces = parent_ele.namespaces.to_a + [options] if parent_ele.present?
              [:namespaces, :settings].each do |attrs|
                result[attrs].each {|element| __convert(result: element, parent_ele: options) } if result[attrs].present?
              end
            else
              result.tap do |attrs|
                attrs[:key] = attrs[:key].to_sym
                attrs[:default] = attrs[:default].to_s
                attrs[:value] = attrs[:value].to_s if attrs[:value].present?
              end
              setting  = ResourceRegistry::Settings::Setting.new(result)
              parent_ele.settings = parent_ele.settings.to_a + [setting]
            end
            root
          end
        end
      end
    end
  end
end