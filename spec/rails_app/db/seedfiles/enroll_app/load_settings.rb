# frozen_string_literal: true

# Boot file to configure system
require 'resource_registry/container'

# Ordereed list of core files to configure system
boot_keys = [:features, :components, :site, :ui, :subscriptions, :component_provision, :aca_shop_market]

# Repository container that manages configuration settings
Repo = ResourceRegistry::Container

# binding.pry

boot_keys.each do |key|
  glob_pattern = File.join('.', 'spec', 'db', 'seedfiles', 'enroll_app', "#{key.to_s}_settings.rb")
  Dir.glob(glob_pattern).each { |file| require file }
end

Repo
# repo.merge(site_repo, namespace: TopNamespaceName)



