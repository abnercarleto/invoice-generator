# Preview all emails at http://localhost:3000/rails/mailers/financial/invoice
class Financial::InvoicePreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/financial/invoice/send_as_file
  def send_as_file
    Financial::InvoiceMailer.send_as_file
  end

end
