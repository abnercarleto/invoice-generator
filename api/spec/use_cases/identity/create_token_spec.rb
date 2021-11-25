require 'rails_helper'

RSpec.describe Identity::CreateToken, type: :use_case do
  describe '.call' do
    subject(:perform_use_case) { described_class.call(email: email) }

    let(:email) { 'user@email.com' }

    context 'when user is not persisted and token is generated' do
      it { expect { perform_use_case }.to change { Identity::User.where(email: email).count }.from(0).to(1) }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_success }

        describe '#data' do
          subject { perform_use_case.data }

          it { is_expected.to eq({ token: Identity::User.find_by(email: email).token }) }
        end
      end
    end

    context 'when user is persisted and token is regenerated' do
      let!(:identity_user) { create(:identity_user, email: email) }

      it { expect { perform_use_case }.to_not change { Identity::User.where(email: email).count }.from(1) }
      it { expect { perform_use_case }.to change { Identity::User.find_by(email: email).token } }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_success }

        describe '#data' do
          subject(:get_data) { perform_use_case.data }

          it { is_expected.to eq({ token: Identity::User.find_by(email: email).token }) }
        end
      end
    end

    context 'when token generation fail becouse email is invalid' do
      let(:email) { 'user.email.com' }

      it { expect { perform_use_case }.to_not change { Identity::User.where(email: email).count }.from(0) }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_failure }

        describe '#data' do
          subject(:get_data) { perform_use_case.data }

          it { is_expected.to eq({ errors: { email: ['is invalid'] } }) }
        end
      end
    end
  end
end