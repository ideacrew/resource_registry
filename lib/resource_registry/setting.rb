# frozen_string_literal: true

require_relative 'validation/setting_contract'

module ResourceRegistry
  class Setting < Dry::Struct

    # @!attribute [r] key
    # ID for this setting
    # @return [Symbol]
    attribute :key,     Types::RequiredSymbol

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


    def item=(val)
      date_range = scan_date_range(val)
      val = date_range if date_range

      super(val)
    end

    private

    def scan_date_range(value)
      dates = value.scan(/(\d{4}\-\d{2}\-\d{2})\.\.(\d{4}\-\d{2}\-\d{2})/).flatten

      if dates.present?
        dates = dates.collect{|str| parse_date(str) }
        Range.new(*dates)
      end
    end

    def parse_date(date)
      Date.strptime(date, "%Y-%m-%d")
    end
  end
end
