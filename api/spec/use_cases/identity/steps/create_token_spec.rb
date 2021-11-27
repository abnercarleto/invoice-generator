require 'rails_helper'

RSpec.describe Identity::Steps::CreateToken, type: :use_case do
  describe '.call' do
    subject(:perform_use_case) { described_class.call(email: email, permit_regenerate: permit_regenerate) }

    let(:email) { 'user@email.com' }

    context 'when user is not persisted and token is generated' do
      let(:permit_regenerate) { false }

      it { expect { perform_use_case }.to change { Identity::User.where(email: email).count }.from(0).to(1) }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_success }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :ok }
        end

        describe '#data' do
          subject { perform_use_case.data }

          it do
            is_expected.to eq({
              email: email,
              token: Identity::User.find_by(email: email).token
            })
          end
        end
      end
    end

    context 'when user is persisted and cannot generate token' do
      let(:permit_regenerate) { false }
      let!(:identity_user) { create(:identity_user, email: email) }

      it { expect { perform_use_case }.to_not change { Identity::User.where(email: email).count }.from(1) }
      it { expect { perform_use_case }.to_not change { Identity::User.find_by(email: email).token } }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_failure }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :token_already_generated }
        end

        describe '#data' do
          subject(:get_data) { perform_use_case.data }

          it { is_expected.to eq({ token_already_generated: true }) }
        end
      end
    end

    context 'when user is persisted and token is regenerated' do
      let(:permit_regenerate) { true }
      let!(:identity_user) { create(:identity_user, email: email) }

      it { expect { perform_use_case }.to_not change { Identity::User.where(email: email).count }.from(1) }
      it { expect { perform_use_case }.to change { Identity::User.find_by(email: email).token } }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_success }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :ok }
        end

        describe '#data' do
          subject(:get_data) { perform_use_case.data }

          it do
            is_expected.to eq({
              email: email,
              token: Identity::User.find_by(email: email).token
            })
          end
        end
      end
    end

    context 'when user is not persisted and token generation fail becouse email is invalid' do
      let(:permit_regenerate) { false }
      let(:email) { 'user.email.com' }

      it { expect { perform_use_case }.to_not change { Identity::User.where(email: email).count }.from(0) }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_failure }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :cannot_generate_token }
        end

        describe '#data' do
          subject(:get_data) { perform_use_case.data }

          it { is_expected.to eq({ errors: { email: ['is invalid'] } }) }
        end
      end
    end
  end
end