module Financial
  module Steps
    class CreateInvoice < Micro::Case
      attributes :user, :number, :date, :company_data, :billing_for, :total_value_cents

      def call!
        invoice = build_invoice
        return Success result: { invoice: invoice } if invoice.save

        Failure :cannot_create_invoice, result: { errors: invoice.errors.messages }
      end

      private

      def build_invoice
        user.invoices.build(
          number: number.presence || last_number.next,
          date: date,
          company_data: company_data,
          billing_for: billing_for,
          total_value_cents: total_value_cents
        )
      end

      def last_number
        user.invoices.sort_by_number.select_only_number.last&.number || 0
      end
    end
  end
end