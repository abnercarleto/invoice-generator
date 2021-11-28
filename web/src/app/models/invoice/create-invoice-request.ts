export interface CreateInvoiceRequest {
  send_to: String[],
  invoice: {
    number: Number,
    date: Date,
    company_data: String,
    billing_for: String,
    total_value_cents: Number
  }
}
