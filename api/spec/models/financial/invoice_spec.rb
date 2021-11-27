require 'rails_helper'

RSpec.describe Financial::Invoice, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user).class_name('Identity::User').inverse_of(:invoices) }
  end

  describe 'validations' do
    subject { create(:financial_invoice) }

    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:company_data) }
    it { is_expected.to validate_presence_of(:billing_for) }
    it { is_expected.to validate_presence_of(:total_value_cents) }
    it { is_expected.to validate_uniqueness_of(:number).scoped_to(:user_id) }
  end
end
