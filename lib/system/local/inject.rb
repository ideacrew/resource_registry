module ResourceRegistry
  
  PrivateInject = PrivateRegistry.injector
  
  # Does this work??
  PrivateTransaction = PrivateRegistry.transaction

  PrivateTransaction = Dry::Transaction(container: PrivateRegistry)
end