module ResourceRegistry
  module Stores
    module Serializers
      class YamlSerializer

        BOOT_KEYS = [:aca_shop_market]

        class << self

          def serialize
          end

          def parse
            BOOT_KEYS.each do |key|

              glob_pattern = File.join(ResourceRegistry.root, 'spec', 'db', 'seedfiles', 'enroll_app', "#{key.to_s}_settings.yml")
              # result = File.open(glob_pattern) {|test| YAML.load(test)}
              # call(result)

              Dir.glob(glob_pattern).each { |path|
                settings = YAML.load(ERB.new(IO.read(path)).result)
                application = call(settings)
              }
            end

            # result = YAML.load(ERB.new(IO.read(@path)).result) if @path and File.exist?(@path)
            # result || {}
          rescue Psych::SyntaxError => e
            # raise "YAML syntax error occurred while parsing #{@path}. " \
            # "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            # "Error: #{e.message}"
          end

          def node_collections
            %w(applications features options)
          end

          def node_class_for(namespace)
            "ResourceRegistry::Options::#{namespace.classify}".constantize
          end

          def set_assoc(parent_ele, collection_name, option)
            records = [option]
            if parent_ele.send(collection_name).present?
              records = parent_ele.send(collection_name) + records
            end
            parent_ele.send("#{collection_name}=", records)
          end

          def call(result)
            root_key = result.keys[0]
            root_class = node_class_for(root_key)
            key, value = result[root_key].first

            @root_element = root_class.new(key: key.to_sym)
            __convert__(result: value, parent_ele: @root_element)
          end

          def __convert__(result: nil, parent_ele: nil, collection_name: nil)
            result.each do |key, value|
              if node_collections.include?(key)
                __convert__(result: value, parent_ele: parent_ele, collection_name: key)
                next
              end

              option_class = node_class_for(collection_name)

              if value.is_a?(Hash)
                if parent_ele.present?
                  option = option_class.new(key: key.to_sym)
                  set_assoc(parent_ele, collection_name, option)
                else
                  option = option_class.new(key: key.to_sym)
                end

                __convert__(result: value, parent_ele: option, collection_name: collection_name)
              else
                option = option_class.new(key: key.to_sym, default: value.to_s)
                set_assoc(parent_ele, collection_name, option)
              end
            end
            parent_ele
          end
        end
      end
    end
  end
end