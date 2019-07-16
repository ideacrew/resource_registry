module ResourceRegistry
  module Service

    def self.included(base)
      base.extend ClassMethods 
    end

    module ClassMethods
      def call(**params)
        new.call(params)
      end
    end
  end
end