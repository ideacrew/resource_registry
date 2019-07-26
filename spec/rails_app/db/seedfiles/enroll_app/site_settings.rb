# nested configuration settings file called from load_settings.rb

Repo.namespace("#{TopNamespaceName}.site") do
  register :tenant_name, ""
  register :components, []
  register :features, []
  register :compenent_subscriptions, []

  register :long_name, "DC HealthLink"
end