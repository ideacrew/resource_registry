require "dry-auto_inject"

## Wrong Way!!
# if census_employee_ssn_required
# else
# end

## Right Way!!
# create_user = FeatureCheck["operations.create_user"]
# create_user.call(name: "Jane")

# census_employee_ssn_feature_check
# feature_check(census_employee_ssn census_employee_ssn_validation)

# feature_check[:admin_portal]
# login_button url_for: feature_check.resolve(:admin_portal)


module ResourceRegistry
  class FeatureCheck < Repository
    Import = Dry::AutoInject(self)

    register "users_repository" do
      UsersRepository.new
    end

    register "operations.create_user" do
      CreateUser.new
    end
  end

  class CreateUser
    include Import["users_repository"]

    def call(user_attrs)
      users_repository.create(user_attrs)
    end
  end

end