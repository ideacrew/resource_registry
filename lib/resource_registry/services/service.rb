module ResourceRegistry
  module Services
    module Service

      def self.included(base)
        base.extend ClassMethods 
      end

      module ClassMethods
        def call(*params)
          new(*params).call
        end
      end

    end
  end
end