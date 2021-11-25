class ApplicationMailer < ActionMailer::Base
  default from: 'noreplay@invoicegenerator.com'
  layout 'mailer'
end
