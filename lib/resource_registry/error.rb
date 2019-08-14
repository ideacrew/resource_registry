module ResourceRegistry
  class Error
    # @api public
    Error = Class.new(StandardError)
    InvalidOptionHash = Class.new(Error)
    InvalidContractParams = Class.new(Error)
    InitializationFileError = Class.new(Error)
    ContainerCreateError = Class.new(Error)

    attr_reader :original

    def initialize(msg, original = $!)
      super(msg)
      @original = original
    end
  end
end