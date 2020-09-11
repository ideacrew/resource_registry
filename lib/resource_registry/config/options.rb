# encoding: utf-8
# frozen_string_literal: true

module ResourceRegistry
  module Config
    # Encapsulates logic for setting options.
    module Options
      # Get the defaults or initialize a new empty hash.
      #
      # @example Get the defaults.
      #   Options.defaults
      #
      # @return [ Hash ] The default options.
      def defaults
        @defaults ||= {}
      end

      # Define a configuration option with a default.
      #
      # @example Define the option.
      #   Options.option(:logger, :default => Logger.new(STDERR, :warn))
      #
      # @param [ Symbol ] name The name of the configuration option.
      # @param [ Hash ] options Extras for the option.
      #
      # @option options [ Object ] :default The default value.
      def option(name, options = {})
        defaults[name] = settings[name] = options[:default]

        class_eval do
          define_method(name) do
            settings[name]
          end

          define_method("#{name}=") do |value|
            settings[name] = value
          end

          define_method("#{name}?") do
            !!send(name)
          end
        end
      end

      # Reset the configuration options to the defaults.
      #
      # @example Reset the configuration options.
      #   Config.reset
      #
      # @return [ Hash ] The defaults.
      def reset
        settings.replace(defaults)
      end

      # Get the settings or initialize a new empty hash.
      #
      # @example Get the settings.
      #   Options.settings
      #
      # @return [ Hash ] The setting options.
      def settings
        @settings ||= {}
      end

      # Get the log level.
      #
      # @example Get the log level.
      #   Config.log_level
      #
      # @return [ Integer ] The log level.
      def log_level
        return unless level = settings[:log_level]
        unless level.is_a?(Integer)
          level = level.upcase.to_s
          level = "Logger::#{level}".constantize
        end
        level
      end
    end
  end
end
