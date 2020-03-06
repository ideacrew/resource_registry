# frozen_string_literal: true

module ResourceRegistry
  module Error
    # @api private
    module ErrorInitalizer
      attr_reader :original
      
      def initialize(msg, original = $!)
        super(msg)
        @original = original
      end
    end
    
    # @api public
    class Error < StandardError
      include ErrorInitalizer
    end
    
    class LoadException < LoadError
      include ErrorInitalizer
    end 

    InvalidConfigurationError = Class.new(Error)
    InvalidOptionHash         = Class.new(Error)
    InvalidContractParams     = Class.new(Error)
    InitializationFileError   = Class.new(LoadException)
    ContainerCreateError      = Class.new(LoadException)
  end
end
