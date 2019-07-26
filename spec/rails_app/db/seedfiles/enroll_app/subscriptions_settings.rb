# nested configuration settings file called from load_settings.rb

Repo.namespace("#{TopNamespaceName}.subscriptions") do
  register :benefit_markets, [:aca_shop_market, :aca_individual_market, :fehb_market]
end
