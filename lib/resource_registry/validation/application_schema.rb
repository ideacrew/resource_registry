require 'dry-schema'

module ResourceRegistry
  module Validation
    class ApplicationSchema < Dry::Schema::Params

      # define common rules, if any
      define do

        # def strip_whitespace(str)
        #   str ? str.strip.chomp : str    
        # end

        # def starts_with_uppercase?(value)
        #   value =~ /^[A-Z]*/ # check that the first character in our string is uppercase
        # end
      end

    end
  end
end