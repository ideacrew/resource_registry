# frozen_string_literal: true

require 'ox'

module ResourceRegistry
  module Serializers
    class XmlSerializer
      # include ResourceRegistry::Services::Service

      def call(**params)
        @content = params[:content]
        @action  = params[:action]

        send(@action)
      end

      def generate
        Ox.dump(@content)
      end

      def parse
        Ox.load(@content, :hash)
      end

    end
  end
end
