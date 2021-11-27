require 'rails_helper'

RSpec.describe Financial::Steps::CreateInvoice, type: :use_case do
  let(:user) { create(:identity_user) }

  describe '.call' do
    subject(:perform_use_case) do
      described_class.call(
        user: user,
        number: number,
        date: date,
        company_data: company_data,
        billing_for: billing_for,
        total_value_cents: total_value_cents
      )
    end

    context 'when create invoice' do
      let(:date) { Time.zone.today }
      let(:company_data) do
        <<~COMPANY
          Company: #{Faker::Company.name}
          Address: #{Faker::Address.full_address}
        COMPANY
      end
      let(:billing_for) do
        <<~BILLING
          Company: #{Faker::Company.name}
          Address: #{Faker::Address.full_address}
        BILLING
      end
      let(:total_value_cents) { SecureRandom.random_number(1..10_000_000_00) }

      context 'and number is informed' do
        let(:number) { SecureRandom.random_number(1..100_000) }

        it { expect { perform_use_case }.to change { Financial::Invoice.where(user: user).count }.from(0).to(1) }

        describe 'result' do
          it { is_expected.to be_a Micro::Case::Result }
          it { is_expected.to be_success }

          describe '#type' do
            subject { perform_use_case.type }

            it { is_expected.to eq :ok }
          end

          describe '#data' do
            subject(:get_data) { perform_use_case.data }

            it { is_expected.to eq({ invoice: Financial::Invoice.last }) }

            describe '#[:invoice]' do
              subject { get_data[:invoice] }

              it do
                is_expected.to have_attributes({
                  number: number,
                  date: date,
                  company_data: company_data,
                  billing_for: billing_for,
                  total_value_cents: total_value_cents
                })
              end
            end
          end
        end
      end

      context 'and number is not informed' do
        let(:number) { nil }

        it { expect { perform_use_case }.to change { Financial::Invoice.where(user: user).count }.from(0).to(1) }

        describe 'result' do
          it { is_expected.to be_a Micro::Case::Result }
          it { is_expected.to be_success }

          describe '#type' do
            subject { perform_use_case.type }

            it { is_expected.to eq :ok }
          end

          describe '#data' do
            subject(:get_data) { perform_use_case.data }

            it { is_expected.to eq({ invoice: Financial::Invoice.last }) }

            describe '#[:invoice]' do
              subject { get_data[:invoice] }

              it do
                is_expected.to have_attributes({
                  number: (a_value > 0),
                  date: date,
                  company_data: company_data,
                  billing_for: billing_for,
                  total_value_cents: total_value_cents
                })
              end
            end
          end
        end
      end
    end

    context 'when not create because some parameter is invalid' do
      let(:number) { 10 }
      let(:date) { Time.zone.today }
      let(:company_data) { nil }
      let(:billing_for) do
        <<~BILLING
          Company: #{Faker::Company.name}
          Address: #{Faker::Address.full_address}
        BILLING
      end
      let(:total_value_cents) { SecureRandom.random_number(1..10_000_000_00) }

      it { expect { perform_use_case }.to_not change { Financial::Invoice.where(user: user).count }.from(0) }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_failure }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :cannot_create_invoice }
        end

        describe '#data' do
          subject(:get_data) { perform_use_case.data }

          it { is_expected.to eq({ errors: { company_data: ["can't be blank"] } }) }
        end
      end
    end
  end
end