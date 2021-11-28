Financial::CreateAndSendInvoice = Micro::Cases.flow([
  Financial::Steps::CreateInvoice,
  Financial::Steps::ExportInvoice,
  Financial::Steps::SendInvoice
])