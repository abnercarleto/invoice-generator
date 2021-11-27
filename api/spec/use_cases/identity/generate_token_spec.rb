require 'rails_helper'

RSpec.describe Identity::GenerateToken, type: :use_case do
  let(:user_mailer) { class_spy('mailer', 'Identity::UserMailer') }
  let(:email) { "user-#{SecureRandom.hex(5)}@email.com" }

  let(:permit_regenerate) { false }

  subject(:perform_flow) { described_class.call(email: email, permit_regenerate: permit_regenerate) }

  before(:each) { stub_const('Identity::UserMailer', user_mailer) }

  describe '.call' do
    context 'when all use cases was executed' do
      describe 'last executed use case' do
        subject { perform_flow.use_case }

        it { is_expected.to be_a Identity::Steps::SendToken }
      end
    end

    context 'when has an error on executing fist use case' do
      describe 'last executed use case' do
        let!(:identity_user) { create(:identity_user, email: email) }
        subject { perform_flow.use_case }

        it { is_expected.to be_a Identity::Steps::CreateToken }
      end
    end
  end
end