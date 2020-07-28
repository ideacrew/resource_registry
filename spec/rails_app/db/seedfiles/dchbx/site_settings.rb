# frozen_string_literal: true

site_repo.namespace(:site) do
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
  register :copyright_period_start, type: :string, default: "::TimeKeeper.date_of_record.year" #{ |vals| vals[:default] }
end


# @repo.namespace(@top_namespace_name) do
#   namespace(:site) do
#     ea_settings_namespace_names = [:aca_shop_market, :aca_individual_market, :fehb_market]
#     load_namespaces(ea_settings_namespace_names)
# end
