require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_secure_token(:token) }

  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to allow_value('example@email.com').for(:email) }
    it { is_expected.to_not allow_value('example.email.com').for(:email) }
    it { is_expected.to validate_length_of(:email).is_at_least(4).is_at_most(254) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end
end
