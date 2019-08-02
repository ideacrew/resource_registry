ResourceRegistry::Registry.namespace(:i18n) do |container|
  load_paths = Dir["#{container.root}/config/locales/**/*.yml"]

  container.boot(:i18n) do
    require "i18n"
    require "dry-validation"

    I18n.load_path += load_paths
    I18n.backend.load_translations

    container.register :t, I18n.method(:t)
  end
end
