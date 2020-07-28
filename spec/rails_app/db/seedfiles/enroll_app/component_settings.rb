# frozen_string_literal: true

# nested configuration settings file called from load_settings.rb


# {
#   site: {
#     key: :ea_in_the_cloud,
#     applications: [
#       ea_application: {},
#     ],
#     tenants: [
#       cca: {},
#       dchbx: {},
#     ],
#     components:
# }
# }

Repo.namespace(:applications) do
  # Entry Point: Enterprise

  register(:enterprise_admin_portal_application,
           type: :symbol,
           default: :enterprise_admin_portal,
           value: :enterprise_admin_portal,
           title: "Web portal for IT staff to configure and administer the site system and services",
           description: "")

  # Entry Point: Enterprise
  register(:ea_application,
           type: :symbol,
           default: :ea_application,
           value: :ea_application,
           title: "Enroll Application application",
           description: "")

  # Entry Point: Enterprise
  register(:edi_db_classic_application,
           type: :symbol,
           default: :edi_db_classic_application,
           value: :edi_db_classic_application,
           title: "EDI Database application (classic)",
           description: "")

  # Entry Point: Enterprise
  register(:edi_db_application,
           type: :symbol,
           default: :edi_db_application,
           value: :edi_db_application,
           title: "EDI Database application",
           description: "")

  # Entry Point: Enterprise
  register(:ledger_application,
           type: :symbol,
           default: :ledger_application,
           value: :ledger_application,
           title: "Ledger application",
           description: "Web portal for accounts, billing and payment")

  # Entry Point: Enterprise
  register(:notice_application,
           type: :symbol,
           default: :notice_application,
           value: :notice_application,
           title: "Notice application",
           description: "")

  # Entry Point: Enterprise
  register(:trans_gw_application,
           type: :symbol,
           default: :trans_gw_application,
           value: :trans_gw_application,
           title: "Transport Gateway application",
           description: "")
end
