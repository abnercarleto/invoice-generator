class Financial::InvoiceMailer < ApplicationMailer

  def send_as_file
    @invoice = params[:invoice]

    invoice_file_name = "invoice-#{@invoice.number}.#{params[:exported_type]}"
    attachments[invoice_file_name] = params[:exported_str]
    mail to: params[:emails], subject: "Invoice #{@invoice.number}, from #{@invoice.company_data[0...30]}..."
  end
end
