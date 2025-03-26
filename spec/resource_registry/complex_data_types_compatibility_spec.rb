# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry, "loading configurations with complex data types" do
  ComplexDataTypeRegistry = ResourceRegistry::Registry.new

  before :all do
    ComplexDataTypeRegistry.configure do |config|
      config.name       = :enroll
      config.created_at = DateTime.now
      config.load_path  = File.join(
        File.dirname(__FILE__),
        "../system/test_registries"
      )
    end
  end

  it "loads the date type feature item" do
    expect(ComplexDataTypeRegistry[:rr_loads_date_type_items].item).to be_kind_of(Date)
  end

  it "loads the date range type feature item as a string" do
    expect(ComplexDataTypeRegistry[:rr_loads_date_range_type_items].item).to be_kind_of(String)
  end

  it "loads the time type feature item" do
    expect(ComplexDataTypeRegistry[:rr_loads_time_type_items].item).to be_kind_of(Time)
  end

  it "loads the symbol type feature item" do
    expect(ComplexDataTypeRegistry[:rr_loads_symbol_type_items].item).to be_kind_of(Symbol)
  end

  it "loads the date type setting item" do
    expect(ComplexDataTypeRegistry[:rr_loads_date_type_items].setting(:rr_loads_date_type_settings).item).to be_kind_of(Date)
  end

  it "loads the date range type setting item as a string" do
    expect(ComplexDataTypeRegistry[:rr_loads_date_range_type_items].setting(:rr_loads_date_range_type_settings).item).to be_kind_of(Range)
  end

  it "loads the time type setting item" do
    expect(ComplexDataTypeRegistry[:rr_loads_time_type_items].setting(:rr_loads_time_type_settings).item).to be_kind_of(Time)
  end

  it "loads the symbol type setting item" do
    expect(ComplexDataTypeRegistry[:rr_loads_symbol_type_items].setting(:rr_loads_symbol_type_settings).item).to be_kind_of(Symbol)
  end
end