module Financial
  module Steps
    class SendInvoice < Micro::Case
      attributes :emails, :invoice, :exported_str, :type

      def call!
        Financial::InvoiceMailer.with(
          invoice: invoice,
          exported_str: exported_str,
          exported_type: type,
          emails: emails
        ).send_as_file.deliver_now

        Success result: { invoice: invoice }
      end
    end
  end
end