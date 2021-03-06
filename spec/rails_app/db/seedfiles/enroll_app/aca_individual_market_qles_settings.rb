# frozen_string_literal: true

# Use the existing QLE settings file for each market
# nested configuration settings file called from load_settings.rb
Repo.namespace(:aca_individual_market_qles) do
  register(:birth,
           title: "Had a baby",
           tool_tip: "Household adds a member due to marriage, birth, adoption, placement for adoption, or placement in foster care",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date of birth",
           reason: "birth",
           edi_code: "02-BIRTH",
           ordinal_position: 10,
           effective_on_kinds: ["date_of_event", "fixed_first_of_next_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: true,
           date_options_available: false)

  register(:adoption,
           title: "Adopted a child",
           tool_tip: "A child has been adopted, placed for adoption, or placed in foster care",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date of adoption",
           ordinal_position: 20,
           reason: "adoption",
           edi_code: "05-ADOPTION",
           effective_on_kinds: ["date_of_event", "fixed_first_of_next_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: true,
           date_options_available: false)

  register(:marriage,
           title: "Married",
           tool_tip: "marriage",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date of marriage",
           ordinal_position: 30,
           reason: "marriage",
           edi_code: "32-MARRIAGE",
           effective_on_kinds: ["first_of_next_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: true,
           date_options_available: false)

  register(:domestic_partnership,
           title: "Entered into a legal domestic partnership",
           tool_tip: "Entering a domestic partnership as permitted or recognized by the #{Settings.aca.state_name}",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date of domestic partnership",
           ordinal_position: 40,
           reason: "domestic_partnership",
           edi_code: "33-ENTERING DOMESTIC PARTNERSHIP",
           effective_on_kinds: ["first_of_next_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: true,
           date_options_available: false)

  register(:divorce,
           title: "Divorced or ended domestic partnership",
           tool_tip: "Divorced, ended a domestic partnership, or legally separated",
           action_kind: "drop_member",
           market_kind: "individual",
           event_kind_label: "Divorce or partnership end date",
           ordinal_position: 45,
           reason: "divorce",
           edi_code: "01-DIVORCE",
           effective_on_kinds: ["first_of_next_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: true,
           date_options_available: false)

  register(:lost_access_to_mec,
           title: "Lost or will soon lose other health insurance ",
           tool_tip: "Someone in the household is losing other health insurance involuntarily",
           action_kind: "add_benefit",
           event_kind_label: "Coverage end date",
           market_kind: "individual",
           ordinal_position: 50,
           reason: "lost_access_to_mec",
           edi_code: "33-LOST ACCESS TO MEC",
           effective_on_kinds: ["first_of_next_month"],
           pre_event_sep_in_days: 60,
           post_event_sep_in_days: 60, # "60 days before loss of coverage and 60 days after",
           is_self_attested: true,
           date_options_available: false)

  register(:relocate,
           title: "Moved or moving to the #{Settings.aca.state_name}",
           tool_tip: " ",
           action_kind: "add_benefit",
           market_kind: "individual",
           event_kind_label: "Date of move",
           ordinal_position: 60,
           reason: "relocate",
           edi_code: "43-CHANGE OF LOCATION",
           effective_on_kinds: ["first_of_next_month"],
           pre_event_sep_in_days: 60,
           post_event_sep_in_days: 60,
           is_self_attested: true,
           date_options_available: false)

  register(:enrollment_error_or_misconduct_hbx,
           title: "Enrollment error caused by #{Settings.site.short_name}",
           tool_tip: "You are not enrolled or are enrolled in the wrong plan because of an error made by #{Settings.site.short_name} or the Department of Health and Human Services",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 70,
           reason: "enrollment_error_or_misconduct_hbx",
           edi_code: " ",
           effective_on_kinds: ["first_of_next_month", "first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:eligibility_change_income,
           title: "Change in income that may impact my tax credits/cost-sharing reductions ",
           tool_tip: "Increases or decreases to income that may impact eligibility for or the dollar amount of household tax credits or cost-sharing reductions.
           (Only applies to those currently enrolled in a plan through #{Settings.site.short_name}).",
           action_kind: "change_benefit",
           market_kind: "individual",
           event_kind_label: "Date of change",
           ordinal_position: 80,
           reason: "eligibility_change_income",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: false)

  register(:contract_violation,
           title: "Health plan contract violation",
           tool_tip: " ",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 90,
           reason: "contract_violation",
           edi_code: "33-CONTRACT VIOLATION",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:qualified_native_american,
           title: "Native American or Alaskan Native",
           tool_tip: " ",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 100,
           reason: "qualified_native_american",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 30,
           is_self_attested: false,
           date_options_available: false)

  register(:lost_hardship_exemption,
           title: "Lost eligibility for a hardship exemption",
           tool_tip: "Someone in the household had an exemption from the individual mandate to have health insurance this year but is no longer eligible for the exemption",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date hardship exemption ends",
           ordinal_position: 100,
           reason: "lost_hardship_exemption",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 30,
           post_event_sep_in_days: 30,
           is_self_attested: false,
           date_options_available: true)

  register(:exceptional_circumstances_civic_service,
           title: "Beginning or ending service with AmeriCorps State and National, VISTA, or NCCC",
           tool_tip: " ",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date service begins or ends",
           ordinal_position: 100,
           reason: "exceptional_circumstances_civic_service",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: true,
           date_options_available: false)

  register(:court_order,
           title: "Court order to provide coverage for someone",
           tool_tip: " ",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date that court orders that coverage starts",
           ordinal_position: 100,
           reason: "court_order",
           edi_code: " ",
           effective_on_kinds: ["exact_date"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: false)

  register(:eligibility_change_immigration_status,
           title: "Newly eligible due to citizenship or immigration status change",
           tool_tip: " ",
           action_kind: "add_benefit",
           market_kind: "individual",
           event_kind_label: "Date of change",
           ordinal_position: 100,
           reason: "eligibility_change_immigration_status",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: false)

  register(:enrollment_error_or_misconduct_issuer,
           title: "Enrollment error caused by my health insurance company",
           tool_tip: "You are not enrolled or are enrolled in the wrong plan because of an error made by your insurance company",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 100,
           reason: "enrollment_error_or_misconduct_issuer",
           edi_code: " ",
           effective_on_kinds: ["first_of_next_month", "first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: false)

  register(:enrollment_error_or_misconduct_non_hbx,
           title: "Enrollment error caused by someone providing me with enrollment assistance",
           tool_tip: "You are not enrolled or are enrolled in the wrong plan because of an error made by a broker, in-person assister, or another expert trained by #{Settings.site.short_name}",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 100,
           reason: "enrollment_error_or_misconduct_non_hbx",
           edi_code: " ",
           effective_on_kinds: ["first_of_next_month", "first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: false)

  register(:eligibility_change_medicaid_ineligible,
           title: "Found ineligible for Medicaid after open enrollment ended",
           tool_tip: "Household member(s) had pending Medicaid eligibility at the end of open enrollment but ineligible determination received after open enrollment ended.",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 100,
           reason: "eligibility_change_medicaid_ineligible",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:eligibility_change_employer_ineligible,
           title: "Found ineligible for employer-sponsored insurance after open enrollment ended",
           tool_tip: "Did not enroll in individual or family coverage because employer was applying to provide coverage through #{Settings.site.short_name} during open enrollment",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 100,
           reason: "eligibility_change_employer_ineligible",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:exceptional_circumstances_natural_disaster,
           title: "A natural disaster prevented enrollment",
           tool_tip: "A natural disaster during open or special enrollment prevented enrollment.",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 100,
           reason: "exceptional_circumstances_natural_disaster",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:exceptional_circumstances_medical_emergency,
           title: "A medical emergency prevented enrollment",
           tool_tip: "A serious medical emergency during open enrollment or special enrollment prevented enrollment",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 100,
           reason: "exceptional_circumstances_medical_emergency",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:exceptional_circumstances_system_outage,
           title: "System outage prevented enrollment",
           tool_tip: "A #{Settings.site.short_name} outage or outage in federal or local data sources close to an open enrollment or special enrollment deadline prevented enrollment",
           action_kind: "add_member",
           market_kind: "individual",
           ordinal_position: 100,
           reason: "exceptional_circumstances_system_outage",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:exceptional_circumstances_domestic_abuse,
           title: "Domestic abuse",
           tool_tip: "A person is leaving an abusive spouse or domestic partner",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date you left the household",
           ordinal_position: 100,
           reason: "exceptional_circumstances_domestic_abuse",
           edi_code: " ",
           effective_on_kinds: ["first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:employer_sponsored_coverage_termination,
           title: "Employer did not pay premiums on time",
           tool_tip: "Employer coverage is ending due to employer’s failure to make payments",
           action_kind: "add_member",
           market_kind: "individual",
           event_kind_label: "Date of notice of plan termination",
           ordinal_position: 100,
           reason: "employer_sponsored_coverage_termination",
           edi_code: " ",
           effective_on_kinds: ["first_of_next_month"],
           pre_event_sep_in_days: 60,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:employee_gaining_medicare,
           title: "Dependent loss of employer-sponsored insurance because employee is enrolling in Medicare ",
           tool_tip: " ",
           action_kind: "add_benefit",
           event_kind_label: "Last day of coverage",
           market_kind: "individual",
           ordinal_position: 14,
           reason: "employee_gaining_medicare",
           edi_code: "33-LOST ACCESS TO MEC",
           effective_on_kinds: ["first_of_next_month"],
           pre_event_sep_in_days: 60,
           post_event_sep_in_days: 60, # "60 days before loss of coverage and 60 days after",
           is_self_attested: true,
           date_options_available: false)

  register(:eligibility_failed_or_documents_not_received_by_due_date,
           title: "Not eligible for marketplace coverage due to citizenship or immigration status",
           tool_tip: " ",
           action_kind: "transition_member",
           market_kind: "individual",
           ordinal_position: 120,
           reason: "eligibility_failed_or_documents_not_received_by_due_date",
           edi_code: " ",
           effective_on_kinds: ["first_of_next_month", "first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)

  register(:eligibility_documents_provided,
           title: "Provided documents proving eligibility",
           tool_tip: " ",
           action_kind: "transition_member",
           market_kind: "individual",
           ordinal_position: 120,
           reason: "eligibility_documents_provided",
           edi_code: " ",
           effective_on_kinds: ["first_of_next_month", "first_of_month"],
           pre_event_sep_in_days: 0,
           post_event_sep_in_days: 60,
           is_self_attested: false,
           date_options_available: true)
end
