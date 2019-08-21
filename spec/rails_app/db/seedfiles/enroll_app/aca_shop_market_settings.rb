# frozen_string_literal: true

# nested configuration settings file called from load_settings.rb

## FIXME -- cross-reference these settings with BenefitMarket Engine seed files to verify comprehensive coverage

Repo.namespace("#{TopNamespaceName}.ea_component") do
  namespace :aca_shop_market do

    register(:enroll_prior_to_effective_on_max,       { title: "", description: "", type: :duration, default: { days: -30 }, value: { days: -30 }})  #{ |vals| Hash(metadata: vals)}
    register(:enroll_after_effective_on_max,          { title: "", description: "", type: :duration, default: { days: 30 }, value: { days: 30 }})  #{ |vals| Hash(metadata: vals)}
    register(:enroll_after_ee_roster_correction_max,  { title: "", description: "", type: :duration, default: { days: 30 }, value: { days: 30 }})  #{ |vals| Hash(metadata: vals)}
    register(:retroactive_coverage_termination_max,   { title: "", description: "", type: :duration, default: { days: -60 }, value: { days: -60 }})  #{ |vals| Hash(metadata: vals)}

    register(:cobra_enrollment_period_max,            { title: "", description: "", type: :duration, default: { months: 6}, value: { months: 6 }})  #{ |vals| Hash(metadata: vals)}
    register(:contact_methods_kinds,                  { title: "", description: "", type:     :enumerated_hash,
                                                        default: { paper_and_electronic: "Paper and Electronic" },
                                                        value: { paper_and_electronic: "Paper and Electronic" },
                                                        enum: [
                                                                    { paper_and_electronic: "Paper and Electronic" },
                                                                    { paper_only: "Paper only" },
                                                                    { electronic_only: "Electronic only" },
] }) #{ |vals| Hash(metadata: vals) }

    # FIXME ?? Is this needed? Change to dependency injection?
    register(:use_simple_employer_calculation_model,     { title: "", description: "", type: :boolean, default: false, value: false })  #{ |vals| Hash(metadata: vals)}

    # FIXME rename or deprecate
    namespace :rename_or_deprecate do
      register(:benefit_period_min_year,                 { title: "", description: "", type: :integer, default: 1, value: 1 })  #{ |vals| Hash(metadata: vals)}
      register(:benefit_period_max_year,                 { title: "", description: "", type: :integer, default: 1, value: 1 })  #{ |vals| Hash(metadata: vals)}

      # Whats this?
      register(:carrier_filters_enabled,                 { title: "", description: "", type: :boolean, default: false, value: false })  #{ |vals| Hash(metadata: vals)}
    end


    # FIXME move these EDI-related settings to EDI DB
    namespace :move_these_settings_to_edi_db do
      ## FIXME: replace gf_update_trans_dow and move this setting to EDI DB
      register(:group_updates_transmit_dow,  { title: "", description: "", type: :string,  default: "friday", value: "friday" })  #{ |vals| Hash(metadata: vals)}

      ## FIXME What is this?
      register(:transmit_scheduled_employers,             { title: "", description: "", type: :boolean, default: true, value: true })  #{ |vals| Hash(metadata: vals)}
      register(:transmit_employers_immediately,          { title: "", description: "", type: :boolean, default: false, value: false })  #{ |vals| Hash(metadata: vals)}

      # FIXME replace group_file_new_enrollment_transmit_on with new_groups_transmit_dom
      # FIXME replace employer_transmission_day_of_month with new_groups_transmit_dom
      # register(:group_file_new_enrollment_transmit_on,   { title: "", description: "", type: :integer, default: 16, value: 16 })  #{ |vals| Hash(metadata: vals)}
      # register(:employer_transmission_day_of_month,      { title: "", description: "", type: :integer, default: 16, value: 16 })  #{ |vals| Hash(metadata: vals)}
      register(:new_groups_transmit_dom,            { title: "", description: "", type: :integer, default: 16, value: 16 })  #{ |vals| Hash(metadata: vals)}


    end

    namespace :benefit_market_catalogs do
      namespace :catalog_2019 do
        register(:application_period,               { title: "", description: "", type: :range,
                                                      default: Date.new(2019,1,1)..Date.new(2019,12,31),
                                                      value: Date.new(2019,1,1)..Date.new(2019,12,31) }) #{ |vals| Hash(metadata: vals) }

        # FIXME add duration for daily post-OE transmission (New Enrollment Exception Processing tools)
        register(:enrollment_transmit_period, { title: "", description: "", type: :range,
                                                default: Date.new(2019, 1, 26)..Date.new(2019, 1, 31),
                                                value: Date.new(2019, 1, 26)..Date.new(2019, 1, 31) })


        register(:application_interval_kind,        { title: "", description: "", type: :enumerated_hash,
                                                      default: { monthly: "Monthly" },
                                                      value: { monthly: "Monthly" },
                                                      enum: [
                                                                  { monthly: "Monthly" },
                                                                  { annual: "Annual" },
                                                                  { annual_with_midyear_initial: "Annual with midyear initial groups" },
]})


        register(:probation_period_kinds,           { title: "", description: "", type:     :enumerated_hash_array,
                                                      default: [
                                                                  { first_of_month_before_15th: "First of month before 15th" },
                                                                  { date_of_hire: "Date of hire" },
                                                                  { first_of_month: "First of month following date of hire" },
                                                                  { first_of_month_after_30_days: "First of month after 30 days following date of hire" },
                                                                  { first_of_month_after_60_days: "First of month after 60 days following date of hire" },
                                                                ],
                                                      value: [
                                                                  { first_of_month: "First of month following date of hire" },
                                                                  { first_of_month_after_30_days: "First of month after 30 days following date of hire" },
                                                                  { first_of_month_after_60_days: "First of month after 60 days following date of hire" },
                                                                ] }) #{ |vals| Hash(metadata: vals) }

        register(:employer_attestation_required,    { title: "", description: "", type: :boolean, default: false, value: false }) { |value| Hash(metadata: value) }

        # FIXME replace standard_industrial_classification with employer_sic_required
        register(:employer_sic_required,            { title: "", description: "", type: :boolean, default: false, value: false })  #{ |vals| Hash(metadata: vals)}
        # register(:standard_industrial_classification,      { title: "", description: "", type: :boolean, default: false, value: false })  #{ |vals| Hash(metadata: vals)}


        register(:employer_contribution_pct_min,    { title: "", description: "", type: :integer, default: 75, value: 75 })  #{ |vals| Hash(metadata: vals)}
        register(:employee_non_owner_count_min,     { title: "", description: "", type: :integer, default: 1, value: 1 })  #{ |vals| Hash(metadata: vals)}
        register(:employee_count_max,               { title: "", description: "", type: :integer, default: 50, value: 50 })  #{ |vals| Hash(metadata: vals)}
        register(:employee_participation_ratio_min, { title: "", description: "", type: :float,   default: 0.75, value: 0.75 })  #{ |vals| Hash(metadata: vals)}


        namespace :month_1 do
          register(:open_enrollment_begin_dom,          { title: "", description: "", type: :integer, default: 1, value: 1 })
          register(:open_enrollment_end_dom,            { title: "", description: "", type: :integer, default: 20, value: 20 })
          register(:binder_payment_due_dom,             { title: "", description: "", type: :integer, default: 24, value: 24 }) #{ |vals| vals }

          register(:open_enrollment_length_days_min,    { title: "", description: "", type: :integer, default: 5, value: 5 })  #{ |vals| Hash(metadata: vals)}
          register(:open_enrollment_length_months_max,  { title: "", description: "", type: :integer, default: 2, value: 2 })  #{ |vals| Hash(metadata: vals)}


          # FIXME New Enrollment Exception Processing tools obsolete these settings - remove from code
          # register(:grace_period_length_days_min, { title: "", description: "", type: :integer, default: 5, value: 5 })  #{ |vals| Hash(metadata: vals)}
          # register(:adv_days_min,                 { title: "", description: "", type: :integer, default: 5, value: 5 })  #{ |vals| Hash(metadata: vals)}
        end

        # FIXME placeholder for any rule definition
        namespace :member_market_policy do
        end


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
        namespace :dd_product_package do
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
        namespace :yy_pricing_model do
          register :name
          register :price_calculator_kind
          register :product_multiplicities
        end

        register(:member_relationship_kinds,  { title: "", description: "", type: :enumerated_hash_array,
                                                default: [
                                                  { employee: "Employee" },
                                                  { spouse: "Spouse" },
                                                  { dependent: "Dependent" },
                                                ],
                                                value: [
                                                  { employee: "Employee" },
                                                  { spouse: "Spouse" },
                                                  { dependent: "Dependent" },
                                                ] })

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

        ## Get with Trey on these
        register :price_calculator_kinds, []
        register :product_multiplicities, []

        register :policies, [:member_market, :metal_level_package, :sponsored_benefit, :subscriber]

      end

    end

  end
end
