FactoryBot.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
  sequence :invoice_number
end