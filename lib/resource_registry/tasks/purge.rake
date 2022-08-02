# frozen_string_literal: true

namespace :resource_registry do

  task :purge => :environment do

    if defined? ::Mongoid::Document
      ResourceRegistry::Mongoid::Feature.delete_all
    else
      ResourceRegistry::ActiveRecord::Feature.delete_all
    end

    puts "::: Settings Delete Complete :::"
    puts "*" * 80 unless Rails.env.test?
  end
end