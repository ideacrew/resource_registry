module ResourceRegistry
  class Error
    # @api public
    Error = Class.new(StandardError)
    InvalidOptionHash = Class.new(Error)
    InvalidContractParams = Class.new(Error)
  end
end