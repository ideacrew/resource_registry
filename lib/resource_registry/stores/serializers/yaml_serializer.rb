module ResourceRegistry
  module Stores
    module Serializers
      class YamlSerializer

        BOOT_KEYS = [:aca_shop_market, :aca_individual_market]
        COLLECTIONS = %W(applications features namespace)

        class << self

          def serialize
          end

          def parse
            configurations = {}

            BOOT_KEYS.each do |key|
              glob_pattern = File.join(ResourceRegistry.root, 'spec', 'db', 'seedfiles', 'enroll_app', "#{key}_settings.yml")

              Dir.glob(glob_pattern).each { |path|
                setting_hash = YAML.load(ERB.new(IO.read(path)).result)
                if setting_hash.empty?
                  configurations = setting_hash
                end
                DeepMerge.deep_merge!(setting_hash, configurations)
              }
            end

            root_key   = configurations.keys[0]
            key, value = configurations[root_key].first
            __convert__(result: value, parent_ele: node_class_for(root_key).new(key: key.to_sym))
          rescue Psych::SyntaxError => e
            # raise "YAML syntax error occurred while parsing #{@path}. " \
            # "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            # "Error: #{e.message}"
          end

          def __convert__(result: nil, parent_ele: nil, collection_name: nil)
            result.each do |key, value|
              if COLLECTIONS.include?(key)
                __convert__(result: value, parent_ele: parent_ele, collection_name: key)
                next
              end
              option_class = node_class_for(collection_name)
              if collection_name.blank?
                attrs = {key: key.to_sym}
                attrs.merge!(value.is_a?(Hash) ? value : {default: value.to_s})
                option = option_class.new(attrs)
                collection_name = 'options' if option.is_a?(ResourceRegistry::Options::Option)
                set_assoc(parent_ele, collection_name, option)
                collection_name = nil
              else
                option = option_class.new(key: key.to_sym)
                set_assoc(parent_ele, collection_name, option)
                __convert__(result: value, parent_ele: option, collection_name: nil)
              end
            end
            parent_ele
          end

          def node_class_for(namespace = nil)
            return ResourceRegistry::Options::Option if namespace.blank?

            if namespace == 'namespace'
              ResourceRegistry::Options::OptionNamespace
            else
              "ResourceRegistry::Options::#{namespace.classify}".constantize
            end
          end

          def set_assoc(parent_ele, collection_name, option)
            collection_name = collection_name.pluralize
            records = [option]
            if parent_ele.send(collection_name).present?
              records = parent_ele.send(collection_name) + records
            end
            parent_ele.send("#{collection_name}=", records)
          end
        end
      end
    end
  end
end