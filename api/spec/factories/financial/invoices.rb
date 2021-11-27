FactoryBot.define do
  factory :financial_invoice, class: 'Financial::Invoice' do
    user factory: :identity_user

    number { generate(:invoice_number) }
    date { Time.zone.today }
    company_data do
      <<~COMPANY
        Company: #{Faker::Company.name}
        Address: #{Faker::Address.full_address}
      COMPANY
    end
    billing_for do
      <<~BILLING
        Company: #{Faker::Company.name}
        Address: #{Faker::Address.full_address}
      BILLING
    end
    total_value_cents { SecureRandom.random_number(1..10_000_000_00) }
  end
end
