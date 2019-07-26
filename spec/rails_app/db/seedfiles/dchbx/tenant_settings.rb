
file_suffix = '*_settings.rb'
settings_file_folder = File.expand_path('./spec/db/seedfiles/dchbx', __dir__)
settings_files = Dir.glob(file_suffix, base: settings_file_folder)

settings = settings_files.reduce({}) do |dictionary, file_name|
  upper_bound = file_name.length - file_suffix.length
  key = file_name[0..upper_bound].to_sym
  dictionary[key] = file_name
  dictionary
end

repo = ResourceRegistry::Repository.new

tenant = "dchbx"
top_namespace = repo.load_namespace("#{tenant}_tenant")
top_namespace_name = top_namespace.name

site_repo = ResourceRegistry::Repository.new
require './spec/db/seedfiles/site_settings.rb'
repo.merge(site_repo, namespace: top_namespace_name)

