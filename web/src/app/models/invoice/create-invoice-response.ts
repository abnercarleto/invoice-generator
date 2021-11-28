export interface CreateInvoiceResponse {
  emails: String[],
  invoice: {
    id: number,
    number: number,
    date: Date,
    company_data: string,
    billing_for: string,
    total_value_cents: number
    created_at: Date,
    updated_at: Date
  }
}
