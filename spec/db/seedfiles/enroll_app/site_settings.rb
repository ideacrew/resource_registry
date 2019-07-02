# nested configuration settings file called from load_settings.rb

Repo.namespace("#{TopNamespaceName}.site") do
  register :subscriptions, []
  register :benefit_markets, [:aca_shop_market, :aca_individual_market, :fehb_market]

  register :long_name, "DC HealthLink"
  register :short_name
  register :byline
  register :domain_name
  register :home_url
  register :help_url
  register :faqs_url
  register :logo_filename
  register :copyright_period_start, { type: :string, default: "::TimeKeeper.date_of_record.year" } #{ |vals| vals[:default] }
end