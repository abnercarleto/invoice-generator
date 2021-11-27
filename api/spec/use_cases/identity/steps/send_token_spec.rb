require 'rails_helper'

RSpec.describe Identity::Steps::SendToken, type: :use_case do
  describe '.call' do
    let(:user_mailer) { class_spy('mailer', 'Identity::UserMailer') }
    let(:email) { "user-#{SecureRandom.hex(5)}@email.com" }
    let(:token) { SecureRandom.hex }

    subject(:perform_use_case) { described_class.call(email: email, token: token) }

    before(:each) { stub_const('Identity::UserMailer', user_mailer) }

    describe 'result' do
      it { is_expected.to be_a Micro::Case::Result }
      it { is_expected.to be_success }

      describe '#data' do
        subject { perform_use_case.data }

        it { is_expected.to eq({ sent_to: email }) }
      end
    end

    describe 'mailer' do
      before(:each) { perform_use_case }

      subject { user_mailer }

      it { is_expected.to have_received(:with).with(email: email, token: token) }
      it { is_expected.to have_received(:new_token) }
      it { is_expected.to have_received(:deliver_now) }
    end
  end
end