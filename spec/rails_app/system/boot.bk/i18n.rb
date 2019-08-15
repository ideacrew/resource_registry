RailsApp::Registry.namespace(:i18n) do |registry|
  load_paths = Dir["#{registry.root}/config/locales/**/*.yml"]

  registry.finalize(:i18n) do
    require "i18n"
    require "dry-validation"

    I18n.load_path += load_paths
    I18n.backend.load_translations

    registry.register :t, I18n.method(:t)
  end
end
