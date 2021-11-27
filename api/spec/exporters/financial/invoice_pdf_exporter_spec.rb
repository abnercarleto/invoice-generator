require 'rails_helper'

RSpec.describe Financial::InvoicePdfExporter, type: :exporter do
  describe '.call' do
    let(:invoice) { build_stubbed(:financial_invoice) }

    subject(:pdf_analizer) do
      PDF::Inspector::Text.
        analyze(described_class.call(invoice: invoice)).
        strings
    end

    it do
      is_expected.to include("Invoice ##{invoice.number}") &
                     include("Date: #{invoice.date.strftime('%a, %-d %b %Y')}") &
                     include("From: #{invoice.company_data.split("\n").join(' ')}") &
                     include("To: #{invoice.billing_for.split("\n").join(' ')}") &
                     include("Value: $#{invoice.total_value_cents / 100.0}")
    end
  end
end