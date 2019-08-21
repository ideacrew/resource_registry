# frozen_string_literal: true

setting :tenants, [:dchbx, :cca]


ea_namespace_namess = [:site, :aca_shop_market, :aca_individual_market, :fehb_market]

def load_namespaces(namespaces)
  ea_namespace_namess.each do |name|
    namespace = Dry::Container::Namespace.new(name)
    container.import namespace
  end
end

ns = Dry::Container::Namespace.new(:tenant1) do
  namespace(:site) do
    register(:tenant) { ThreadSafe::Array.new }
  end
  # namespace(:aca_shop_market)
end


setting :dchbx_tenant do
  setting :tenant_key, :dchbx
  setting :long_name
  setting :short_name
  setting :byline
  setting :domain_name
  setting :home_url
  setting :help_url
  setting :faqs_url
  setting :logo
  setting(:copyright_period_start,  { type: :string,
                                      default: ->{ ::TimeKeeper.date_of_record.year },
                                      value: ->{ ::TimeKeeper.date_of_record.year }}) \
                                    { |vals| Hash(metadata: vals) }


  setting :site do
    setting :subscriptions, []
    setting :benefit_markets, [:aca_shop_market, :aca_individual_market, :fehb_market]
  end



  setting :aca_shop_market do
    setting(:binder_payment_due_day_of_month,                   { type: :integer, default: 24, value: 24 }) { |vals| vals }
    setting(:earliest_enroll_prior_effective_on_days,           { type: :integer, default: -30, value: -30 }) { |vals| Hash(metadata: vals)}
    setting(:latest_enroll_after_effective_on_days,             { type: :integer, default: 30, value: 30 }) { |vals| Hash(metadata: vals)}
    setting(:latest_enroll_after_ee_roster_correction_on_days,  { type: :integer, default: 30, value: 30 }) { |vals| Hash(metadata: vals)}

    setting(:retroactive_coverage_termination_max_days,         { type: :integer, default: -60, value: -60 }) { |vals| Hash(metadata: vals)}

    setting :open_enrollment do
      setting(:start_on_monthly,              { type: :integer, default: 1, value: 1 }) { |vals| Hash(metadata: vals)}
      setting(:end_on_monthly,                { type: :integer, default: 20, value: 20 }) { |vals| Hash(metadata: vals)}
      setting(:days_min,                      { type: :integer, default: 5, value: 5 }) { |vals| Hash(metadata: vals)}
      setting(:grace_period_length_days_min,  { type: :integer, default: 5, value: 5 }) { |vals| Hash(metadata: vals)}
      setting(:adv_days_min,                  { type: :integer, default: 5, value: 5 }) { |vals| Hash(metadata: vals)}
      setting(:months_max,                    { type: :integer, default: 2, value: 2 }) { |vals| Hash(metadata: vals)}
    end

    setting(:cobra_enrollment_period_month,             { type: :integer, default: 6, value: 6 }) { |vals| Hash(metadata: vals)}

    setting :group do
      setting(:enforce_employer_attestation,            { type: :boolean, default: true, value: true }) { |vals| Hash(metadata: vals)}

      # Dups?
      setting(:gf_update_trans_dow,                     { type: :boolean, default: false, value: false }) { |vals| Hash(metadata: vals)}
      setting(:group_file_update_transmit_day_of_week,  { type: :string,  default: "friday", value: "friday" }) { |vals| Hash(metadata: vals)}
      setting(:employer_transmission_day_of_month,      { type: :integer, default: 16, value: 16 }) { |vals| Hash(metadata: vals)}
      setting(:group_file_new_enrollment_transmit_on,   { type: :integer, default: 16, value: 16 }) { |vals| Hash(metadata: vals)}

      setting(:employer_contribution_pct_min,           { type: :integer, default: 75, value: 75 }) { |vals| Hash(metadata: vals)}

      setting(:employee_count_max,                      { type: :integer, default: 50, value: 50 }) { |vals| Hash(metadata: vals)}
      setting(:employee_participation_ratio_min,        { type: :float,   default: 0.75, value: 0.75 }) { |vals| Hash(metadata: vals)}
      setting(:employee_non_owner_count_min,            { type: :integer, default: 1, value: 1 }) { |vals| Hash(metadata: vals)}
    end

    setting(:use_simple_employer_calculation_model,     { type: :boolean, default: false, value: false }) { |vals| Hash(metadata: vals)}


    setting :rename_or_deprecate do
      setting(:standard_industrial_classification,      { type: :boolean, default: false, value: false }) { |vals| Hash(metadata: vals)}
      setting(:benefit_period_min_year,                 { type: :integer, default: 1, value: 1 }) { |vals| Hash(metadata: vals)}
      setting(:benefit_period_max_year,                 { type: :integer, default: 1, value: 1 }) { |vals| Hash(metadata: vals)}
      setting(:transmit_employers_immediately,          { type: :boolean, default: false, value: false }) { |vals| Hash(metadata: vals)}
      setting(:transmit_scheduled_employers,            { type: :boolean, default: true, value: true }) { |vals| Hash(metadata: vals)}
      setting(:carrier_filters_enabled,                 { type: :boolean, default: false, value: false }) { |vals| Hash(metadata: vals)}
    end


    setting :benefit_market_catalogs do
      setting :catalog_2018 do
        setting :application_interval, :monthly
        setting(:open_enrollment_minimum_days,  { type: :integer, default: 5, value: 5 }) { |value| Hash(metadata: value) }
        setting(:employer_attestation_required, { type: :boolean, default: false, value: false }) { |value| Hash(metadata: value) }
        setting(:application_period,  { type: :date_range,
                                        default: Date.new(2018,1,1)..Date.new(2018,12,31),
                                        value: Date.new(2018,1,1)..Date.new(2018,12,31) }) \
                                      { |vals| Hash(metadata: vals) }


        setting :product_packages, [:cc, :dd]
        setting :cc_product_package do
          setting :application_period
          setting :product_kind
          setting :package_kind
          setting :title
          setting :description
          setting :products, []
          setting :contribution_model
          setting :pricing_model
        end
        setting :dd_product_package do
        end

        setting :contribution_models, [:aa, :bb]
        setting :aa_contribution_model do
          setting :title
          setting :key
          setting :sponsor_contribution_kind
          setting :contribution_calculator_kind
          setting :many_simultaneous_contribution_units
          setting :product_multiplicities
          setting :contribution_units
          setting :member_relationships
        end
        setting :bb_contribution_model do
          setting :title
          setting :key
          setting :sponsor_contribution_kind
          setting :contribution_calculator_kind
          setting :many_simultaneous_contribution_units
          setting :product_multiplicities
          setting :contribution_units
          setting :member_relationships
        end

        setting :pricing_models, [:xx, :yy]
        setting :xx_pricing_model do
          setting :name
          setting :price_calculator_kind
          setting :product_multiplicities
        end
        setting :yy_pricing_model do
          setting :name
          setting :price_calculator_kind
          setting :product_multiplicities
        end

        setting :member_relationships, [:employee, :spouse, :life_partner, :dependent]
        setting :employee_member_relationship do
          setting :name, :employee
          setting :relationship_kinds, [:self]
        end
        setting :spouse_member_relationship do
          setting :name, :spouse
          setting :relationship_kinds, [:spouse, :life_partner]
        end
        setting :dependent_member_relationship do
          setting :name, :dependent
          setting :relationship_kinds, [:child, :adopted_child, :foster_child, :stepchild, :ward]
          setting :age_threshold, 27
        end

        setting :pricing_units, [:employee, :spouse, :dependent]
        setting :employee_pricing_unit do
          setting :name, :employee
          setting :display_name, "employee"
          setting :order, 1
        end

        setting :price_calculator_kinds, []
        setting :product_multiplicities, []

        setting :policies, [:member_market, :metal_level_package, :sponsored_benefit, :subscriber]
        setting :member_market_policy do
        end

        setting(:application_interval_kinds,  { type: :array,
                                                default: [:monthly, :annual, :annual_with_midyear_initial],
                                                value: [:monthly, :annual, :annual_with_midyear_initial] }) \
          { |vals| Hash(metadata: vals) }

        setting(:probation_period_kinds,  { type: :array,
                                            default: [:first_of_month_before_15th, :date_of_hire, :first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days],
                                            value: [:first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days] }) \
          { |vals| Hash(metadata: vals) }

        setting(:contact_methods_kinds,   { type: :array,
                                            default: [:paper_and_electronic, :paper_only, :electronic_only],
                                            value: [:paper_and_electronic, :paper_only, :electronic_only] }) \
          { |vals| Hash(metadata: vals) }


      end

      setting :catalog_2019 do
        setting :application_interval, :monthly
        setting :employer_attestation_required, false
        setting(:open_enrollment_minimum_days,  { type: :integer, default: 5, value: 5 }) { |value| Hash(metadata: value) }
        setting(:employer_attestation_required, { type: :boolean, default: false, value: false }) { |value| Hash(metadata: value) }
        setting(:application_period,  { type: :date_range,
                                        default: Date.new(2019,1,1)..Date.new(2019,12,31),
                                        value: Date.new(2019,1,1)..Date.new(2019,12,31) }) \
                                      { |vals| Hash(metadata: vals) }


        setting(:application_interval_kinds,  { type: :array,
                                                default: [:monthly, :annual, :annual_with_midyear_initial],
                                                value: [:monthly, :annual, :annual_with_midyear_initial] }) \
                                              { |vals| Hash(metadata: vals) }

        setting(:probation_period_kinds,  { type: :array,
                                            default: [:first_of_month_before_15th, :date_of_hire, :first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days],
                                            value: [:first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days] }) \
                                          { |vals| Hash(metadata: vals) }

        setting(:contact_methods_kinds,   { type: :array,
                                            default: [:paper_and_electronic, :paper_only, :electronic_only],
                                            value: [:paper_and_electronic, :paper_only, :electronic_only] }) \
                                          { |vals| Hash(metadata: vals) }
      end
    end
  end

  setting :fehb_market do
    setting :benefit_market_catalogs do
      setting :benefit_market_catalog_2018 do
        setting :application_interval, :annual
        setting :probation_period_kinds, [:first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days]
      end
      setting :benefit_market_catalog_2019 do
        setting :application_interval, :annual
        setting :probation_period_kinds, [:first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days]
      end
    end
  end

  setting :aca_individual_market do
  end
end