require 'rails_helper'

RSpec.describe Financial::CreateAndSendInvoice, type: :use_case do
  describe '.call' do
    let(:user) { create(:identity_user) }
    let(:exporter) { Financial::InvoicePdfExporter }
    let(:emails) { (1..3).map { Faker::Internet.email } }
    let(:invoice_attrs) { attributes_for(:financial_invoice) }

    subject(:perform_flow) do
      described_class.call(
        user: user,
        exporter: exporter,
        emails: emails,
        **invoice_attrs
      )
    end

    context 'when all use cases was executed' do
      describe 'last executed use case' do
        subject { perform_flow.use_case }

        it { is_expected.to be_a Financial::Steps::SendInvoice }
      end
    end

    context 'when has an error on executing fist use case' do
      describe 'last executed use case' do
        let(:invoice_attrs) { attributes_for(:financial_invoice, company_data: nil) }

        subject { perform_flow.use_case }

        it { is_expected.to be_a Financial::Steps::CreateInvoice }
      end
    end
  end
end