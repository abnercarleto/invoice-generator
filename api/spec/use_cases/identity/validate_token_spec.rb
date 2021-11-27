require 'rails_helper'

RSpec.describe Identity::ValidateToken, type: :use_case do
  subject(:perform_use_case) { described_class.call(token: token) }

  describe '.call' do
    context 'when token is valid' do
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

          it { is_expected.to eq({ validated: true }) }
        end
      end
    end

    context 'when token is not valid' do
      let(:token) { SecureRandom.hex }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_failure }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :error }
        end

        describe '#data' do
          subject { perform_use_case.data }

          it { is_expected.to eq({ validated: false }) }
        end
      end
    end
  end
end