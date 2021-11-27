require 'rails_helper'

RSpec.describe Identity::RemoveToken, type: :use_case do
  describe '.call' do
    subject(:perform_use_case) { described_class.call(token: token) }

    context 'when remove token' do
      let(:token) { create(:identity_user).token }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_success }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :ok }
        end

        describe '#data' do
          subject { perform_use_case.data }

          it { is_expected.to eq({ logout: true }) }
        end
      end
    end

    context 'when token not found' do
      let(:token) { SecureRandom.hex }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_failure }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :user_not_found }
        end

        describe '#data' do
          subject { perform_use_case.data }

          it { is_expected.to eq({ user_not_found: true }) }
        end
      end
    end
  end
end