FactoryBot.define do
  factory :identity_user, class: Identity::User do
    email { generate(:email) }
  end
end
