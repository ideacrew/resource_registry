# Boot file to configure system 

tenant = "dchbx"

# Ordereed list of core files to configure system
boot_keys = [:features, :components, :site, :ui, :subscriptions, :component_provision, :aca_shop_market]

# Enable multiple tenants in same report by setting root namespace
TopNamespaceName = "#{tenant}_tenant"

# Repository container that manages configuration settings
Repo = ResourceRegistry::Repository.new(top_namespace: TopNamespaceName)

binding.pry

boot_keys.each do |key|
  glob_pattern = File.join('.', 'spec', 'db', 'seedfiles', 'enroll_app', "#{key.to_s}_settings.rb")
  Dir.glob(glob_pattern).each { |file| require file }
end

Repo
# repo.merge(site_repo, namespace: TopNamespaceName)



