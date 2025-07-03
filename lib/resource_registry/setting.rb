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
      convert_range_strings(self[:item])
    end

    private

    def convert_range_strings(value)
      return value unless value.is_a?(String)
      return value unless value.include?('..')

      range, success = attempt_to_convert_to_date_range(value)
      success ? range : value
    end

    def attempt_to_convert_to_date_range(value)
      split_result = value.split('..', 2).map(&:strip)
      return [value, false] if split_result.size != 2

      begin_str, end_str = split_result
      return [value, false] unless looks_like_date?(begin_str) && looks_like_date?(end_str)

      begin_date = parse_date(begin_str)
      end_date   = parse_date(end_str)
      return [value, false] unless begin_date && end_date

      [(begin_date..end_date), true]
    end

    DATE_PATTERNS = [
      /^\d{4}-\d{1,2}-\d{1,2}$/,
      /^\d{4}\/\d{1,2}\/\d{1,2}$/,
      /^\d{1,2}\/\d{1,2}\/\d{4}$/
    ].freeze

    def looks_like_date?(str)
      DATE_PATTERNS.any? { |re| str.match?(re) }
    end

    def parse_date(str)
      case str
      when /^\d{4}-\d{1,2}-\d{1,2}$/
        Date.strptime(str, "%Y-%m-%d")
      when /^\d{4}\/\d{1,2}\/\d{1,2}$/
        Date.strptime(str, "%Y/%m/%d")
      when /^\d{1,2}\/\d{1,2}\/\d{4}$/
        Date.strptime(str, "%m/%d/%Y")
      else
        nil
      end
    end
  end
end
