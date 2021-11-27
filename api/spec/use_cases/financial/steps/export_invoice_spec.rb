require 'rails_helper'

RSpec.describe Financial::Steps::ExportInvoice, type: :use_case do
  describe '.call' do
    let(:invoice) { build_stubbed(:financial_invoice) }

    subject(:perform_use_case) { described_class.call(invoice: invoice, exporter: exporter) }

    context 'when export is Financial::InvoicePdfExporter' do
      let(:exporter) { Financial::InvoicePdfExporter }

      describe 'result' do
        it { is_expected.to be_a Micro::Case::Result }
        it { is_expected.to be_success }

        describe '#type' do
          subject { perform_use_case.type }

          it { is_expected.to eq :ok }
        end

        describe '#data' do
          subject(:get_data) { perform_use_case.data }

          it { is_expected.to eq({ exported_str: Financial::InvoicePdfExporter.call(invoice: invoice), type: :pdf }) }
        end
      end
    end
  end
end