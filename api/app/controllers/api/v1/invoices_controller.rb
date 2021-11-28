class Api::V1::InvoicesController < ApplicationController
  before_action :authenticate_user

  def create
    Financial::CreateAndSendInvoice.
      call(
        user: authenticated_user,
        exporter: Financial::InvoicePdfExporter,
        emails: params.require(:send_to),
        **create_invoice_permitted_params
      ).
      on_success { |result| render json: result.data }.
      on_failure { |result| render json: result.data, status: :unprocessable_entity }
  end

  private

  def create_invoice_permitted_params
    params.require(:invoice).permit(:number, :date, :company_data, :billing_for, :total_value_cents)
  end
end
