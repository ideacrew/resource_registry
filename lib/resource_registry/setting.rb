# frozen_string_literal: true

require_relative 'validation/setting_contract'

module ResourceRegistry
  class Setting < Dry::Struct

    # @!attribute [r] key
    # ID for this setting
    # @return [Symbol]
    attribute :key,     Types::Symbol.meta(omittable: false)

    # @!attribute [r] item
    # The value for this setting
    # @return [Any]
    attribute :item,    Types::Any.meta(omittable: false)

    # @!attribute [r] options
    # Options passed through for this setting
    # @return [Hash]
    attribute :options, Types::Any.optional.meta(omittable: true)

    # @!attribute [r] meta
    # Configuration settings and attributes that support presenting and updating
    # their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,    ResourceRegistry::Meta.optional.meta(omittable: true)

    # Override accessor to normalize date range strings
    def item
      @normalized_item ||= convert_range_strings(self[:item])
    end

    private

    def convert_range_strings(value)
      return value if value.is_a?(Range)

      if value.is_a?(String) && value.include?("..")
        begin_str, end_str = value.split("..").map(&:strip)
        begin_date = parse_date(begin_str)
        end_date = parse_date(end_str)
        return (begin_date..end_date) if begin_date && end_date
        return nil
      end

      value
    end

    def parse_date(str)
      # Accepts: YYYY-MM-DD, YYYY/MM/DD, MM/DD/YYYY
      date_formats = [
        "%Y-%m-%d",
        "%Y/%m/%d",
        "%m/%d/%Y"
      ]
      date_formats.each do |fmt|
        begin
          return Date.strptime(str, fmt)
        rescue ArgumentError
          next
        end
      end
      nil
    end
  end
end
