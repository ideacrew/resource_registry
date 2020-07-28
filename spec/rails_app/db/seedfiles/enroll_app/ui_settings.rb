# frozen_string_literal: true

# nested configuration settings file called from load_settings.rb

Repo.namespace("#{TopNamespaceName}.ui") do
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
