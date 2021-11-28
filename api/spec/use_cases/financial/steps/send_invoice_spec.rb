require 'rails_helper'

RSpec.describe Financial::Steps::SendInvoice, type: :use_case do
  describe '.call' do
    let(:invoice_mailer) { class_spy('mailer', 'Financial::InvoiceMailer') }
    let(:invoice) { build_stubbed(:financial_invoice) }
    let(:exported_str) { Faker::Lorem.paragraph(sentence_count: 4) }
    let(:type) { :pdf }
    let(:emails) { (1..3).map { Faker::Internet.email } }

    subject(:perform_use_case) do
      described_class.call(
        invoice: invoice,
        exported_str: exported_str,
        type: type,
        emails: emails
      )
    end

    before(:each) { stub_const('Financial::InvoiceMailer', invoice_mailer) }

    describe 'result' do
      it { is_expected.to be_a Micro::Case::Result }
      it { is_expected.to be_success }

      describe '#data' do
        subject { perform_use_case.data }

        it { is_expected.to eq({ invoice: invoice }) }
      end
    end

    describe 'mailer' do
      before(:each) { perform_use_case }

      subject { invoice_mailer }

      it do
        is_expected.to have_received(:with).with(
          invoice: invoice,
          exported_str: exported_str,
          exported_type: type,
          emails: emails
        )
      end
      it { is_expected.to have_received(:send_as_file) }
      it { is_expected.to have_received(:deliver_now) }
    end
  end
end