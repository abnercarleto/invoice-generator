require "rails_helper"

RSpec.describe Financial::InvoiceMailer, type: :mailer do
  describe "send_as_file" do
    let(:invoice) { build_stubbed(:financial_invoice) }
    let(:exported_str) { Financial::InvoicePdfExporter.call(invoice: invoice) }
    let(:exported_type) { :pdf }
    let(:emails) { [Faker::Internet.email] }

    subject(:mail) do
      described_class.
        with(
          invoice: invoice,
          exported_str: exported_str,
          exported_type: exported_type,
          emails: emails
        ).
        send_as_file
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Invoice #{invoice.number}, from #{invoice.company_data[0...30]}...")
      expect(mail.from).to eq ['noreplay@invoicegenerator.com']
      expect(mail.to).to eq emails
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Invoice #{invoice.number}") &
                                   match(invoice.date.strftime('%a, %-d %b %Y'))
    end
  end

end
