require 'rails_helper'

RSpec.describe Identity::User, type: :model do
  it { is_expected.to have_secure_token(:token) }

  describe 'associations' do
    it { is_expected.to have_many(:invoices).class_name('Financial::Invoice').inverse_of(:user) }
  end

  describe 'validations' do
    subject { build(:identity_user) }

    it { is_expected.to allow_value('example@email.com').for(:email) }
    it { is_expected.to_not allow_value('example.email.com').for(:email) }
    it { is_expected.to validate_length_of(:email).is_at_least(4).is_at_most(254) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end
