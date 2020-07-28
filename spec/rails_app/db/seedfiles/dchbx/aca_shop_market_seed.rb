# frozen_string_literal: true

namespace :aca_shop_market do
  register(:binder_payment_due_day_of_month,                     type: :integer, default: 24, value: 24) { |vals| vals }
  register(:earliest_enroll_prior_effective_on_days,             type: :integer, default: -30, value: -30) { |vals| Hash(metadata: vals)}
  register(:latest_enroll_after_effective_on_days,               type: :integer, default: 30, value: 30) { |vals| Hash(metadata: vals)}
  register(:latest_enroll_after_ee_roster_correction_on_days,    type: :integer, default: 30, value: 30) { |vals| Hash(metadata: vals)}

  register(:retroactive_coverage_termination_max_days,           type: :integer, default: -60, value: -60) { |vals| Hash(metadata: vals)}

  namespace :open_enrollment do
    register(:start_on_monthly,                type: :integer, default: 1, value: 1) { |vals| Hash(metadata: vals)}
    register(:end_on_monthly,                  type: :integer, default: 20, value: 20) { |vals| Hash(metadata: vals)}
    register(:days_min,                        type: :integer, default: 5, value: 5) { |vals| Hash(metadata: vals)}
    register(:grace_period_length_days_min,    type: :integer, default: 5, value: 5) { |vals| Hash(metadata: vals)}
    register(:adv_days_min,                    type: :integer, default: 5, value: 5) { |vals| Hash(metadata: vals)}
    register(:months_max,                      type: :integer, default: 2, value: 2) { |vals| Hash(metadata: vals)}
  end

  register(:cobra_enrollment_period_month,               type: :integer, default: 6, value: 6)

  namespace :group do
    register(:enforce_employer_attestation,              type: :boolean, default: true, value: true)

    # Dups?
    register(:gf_update_trans_dow,                       type: :boolean, default: false, value: false)
    register(:group_file_update_transmit_day_of_week,    type: :string,  default: "friday", value: "friday")
    register(:employer_transmission_day_of_month,        type: :integer, default: 16, value: 16)
    register(:group_file_new_enrollment_transmit_on,     type: :integer, default: 16, value: 16)

    register(:employer_contribution_pct_min,             type: :integer, default: 75, value: 75)

    register(:employee_count_max,                        type: :integer, default: 50, value: 50)
    register(:employee_participation_ratio_min,          type: :float,   default: 0.75, value: 0.75)
    register(:employee_non_owner_count_min,              type: :integer, default: 1, value: 1)
  end

  register(:use_simple_employer_calculation_model,       type: :boolean, default: false, value: false) { |vals| Hash(metadata: vals)}


  namespace :rename_or_deprecate do
    register(:standard_industrial_classification,        type: :boolean, default: false, value: false) { |vals| Hash(metadata: vals)}
    register(:benefit_period_min_year,                   type: :integer, default: 1, value: 1) { |vals| Hash(metadata: vals)}
    register(:benefit_period_max_year,                   type: :integer, default: 1, value: 1) { |vals| Hash(metadata: vals)}
    register(:transmit_employers_immediately,            type: :boolean, default: false, value: false) { |vals| Hash(metadata: vals)}
    register(:transmit_scheduled_employers,              type: :boolean, default: true, value: true) { |vals| Hash(metadata: vals)}
    register(:carrier_filters_enabled,                   type: :boolean, default: false, value: false) { |vals| Hash(metadata: vals)}
  end


  namespace :benefit_market_catalogs do
    register :catalog_2018 do
      register :application_interval, :monthly
      register(:open_enrollment_minimum_days,    type: :integer, default: 5, value: 5) { |value| Hash(metadata: value) }
      register(:employer_attestation_required,   type: :boolean, default: false, value: false) { |value| Hash(metadata: value) }
      register(:application_period,    type: :date_range,
                                       default: Date.new(2018,1,1)..Date.new(2018,12,31),
                                       value: Date.new(2018,1,1)..Date.new(2018,12,31)) \
        { |vals| Hash(metadata: vals) }


      register :product_packages, [:cc, :dd]
      namespace :cc_product_package do
        register :application_period
        register :product_kind
        register :package_kind
        register :title
        register :description
        register :products, []
        register :contribution_model
        register :pricing_model
      end
      register :dd_product_package do
      end

      register :contribution_models, [:aa, :bb]
      namespace :aa_contribution_model do
        register :title
        register :key
        register :sponsor_contribution_kind
        register :contribution_calculator_kind
        register :many_simultaneous_contribution_units
        register :product_multiplicities
        register :contribution_units
        register :member_relationships
      end
      namespace :bb_contribution_model do
        register :title
        register :key
        register :sponsor_contribution_kind
        register :contribution_calculator_kind
        register :many_simultaneous_contribution_units
        register :product_multiplicities
        register :contribution_units
        register :member_relationships
      end

      register :pricing_models, [:xx, :yy]
      namespace :xx_pricing_model do
        register :name
        register :price_calculator_kind
        register :product_multiplicities
      end
      register :yy_pricing_model do
        register :name
        register :price_calculator_kind
        register :product_multiplicities
      end

      register :member_relationships, [:employee, :spouse, :life_partner, :dependent]
      namespace :employee_member_relationship do
        register :name, :employee
        register :relationship_kinds, [:self]
      end
      namespace :spouse_member_relationship do
        register :name, :spouse
        register :relationship_kinds, [:spouse, :life_partner]
      end
      namespace :dependent_member_relationship do
        register :name, :dependent
        register :relationship_kinds, [:child, :adopted_child, :foster_child, :stepchild, :ward]
        register :age_threshold, 27
      end

      register :pricing_units, [:employee, :spouse, :dependent]
      namespace :employee_pricing_unit do
        register :name, :employee
        register :display_name, "employee"
        register :order, 1
      end

      register :price_calculator_kinds, []
      register :product_multiplicities, []

      register :policies, [:member_market, :metal_level_package, :sponsored_benefit, :subscriber]
      register :member_market_policy do
      end

      register(:application_interval_kinds,    type: :array,
                                               default: [:monthly, :annual, :annual_with_midyear_initial],
                                               value: [:monthly, :annual, :annual_with_midyear_initial]) \
        { |vals| Hash(metadata: vals) }

      register(:probation_period_kinds,    type: :array,
                                           default: [:first_of_month_before_15th, :date_of_hire, :first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days],
                                           value: [:first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days]) \
        { |vals| Hash(metadata: vals) }

      register(:contact_methods_kinds,     type: :array,
                                           default: [:paper_and_electronic, :paper_only, :electronic_only],
                                           value: [:paper_and_electronic, :paper_only, :electronic_only]) \
        { |vals| Hash(metadata: vals) }


    end

    namespace :catalog_2019 do
      register :application_interval, :monthly
      register :employer_attestation_required, false
      register(:open_enrollment_minimum_days,    type: :integer, default: 5, value: 5) { |value| Hash(metadata: value) }
      register(:employer_attestation_required,   type: :boolean, default: false, value: false) { |value| Hash(metadata: value) }
      register(:application_period,    type: :date_range,
                                       default: Date.new(2019,1,1)..Date.new(2019,12,31),
                                       value: Date.new(2019,1,1)..Date.new(2019,12,31)) \
        { |vals| Hash(metadata: vals) }


      register(:application_interval_kinds,    type: :array,
                                               default: [:monthly, :annual, :annual_with_midyear_initial],
                                               value: [:monthly, :annual, :annual_with_midyear_initial]) \
        { |vals| Hash(metadata: vals) }

      register(:probation_period_kinds,    type: :array,
                                           default: [:first_of_month_before_15th, :date_of_hire, :first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days],
                                           value: [:first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days]) \
        { |vals| Hash(metadata: vals) }

      register(:contact_methods_kinds,     type: :array,
                                           default: [:paper_and_electronic, :paper_only, :electronic_only],
                                           value: [:paper_and_electronic, :paper_only, :electronic_only]) \
        { |vals| Hash(metadata: vals) }
    end
  end
end
