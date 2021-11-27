module Financial
  class InvoicePdfExporter
    attr_reader :invoice

    class << self
      def call(**kwargs)
        new(**kwargs).call!
      end

      def type
        :pdf
      end
    end

    def initialize(invoice:)
      @invoice = invoice
    end

    def call!
      pdf = Prawn::Document.new
      pdf.text "Invoice ##{invoice.number}"
      pdf.text "Date: #{invoice.date.strftime('%a, %-d %b %Y')}"
      pdf.text "From: #{invoice.company_data.split("\n").join(' ')}"
      pdf.text "To: #{invoice.billing_for.split("\n").join(' ')}"
      pdf.text "Value: $#{invoice.total_value_cents / 100.0}"
      pdf.render
    end
  end
end