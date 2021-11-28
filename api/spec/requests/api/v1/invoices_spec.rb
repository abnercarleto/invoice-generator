require 'rails_helper'

RSpec.describe "Api::V1::Invoices", type: :request do
  let(:json_body) { JSON.parse(response.body) }

  describe "POST /api/v1/invoices" do
    let(:user) { create(:identity_user) }
    let(:emails) { [Faker::Internet.email] }
    let(:invoice_attrs) { attributes_for(:financial_invoice) }
    let(:invoice_params) { invoice_attrs }

    context 'when user is not authorized' do
      it 'unauthorize request' do
        headers = { 'x-auth-token' => SecureRandom.hex }
        post '/api/v1/invoices', params: { format: :json, send_to: emails, invoice: invoice_params }, headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(json_body).to be_blank
      end
    end

    context 'when user is authorized' do
      context 'and invoice is created and sent' do
        it 'return invoice created and emails that invoice wast sent' do
          headers = { 'x-auth-token' => user.token }
          post '/api/v1/invoices', params: { format: :json, send_to: emails, invoice: invoice_params }, headers: headers

          expect(response).to have_http_status(:ok)
          expect(json_body).to eq({ 'invoice' => Financial::Invoice.last.as_json, 'emails' => emails })
        end
      end

      context 'and invoice is not created' do
        let(:invoice_attrs) { attributes_for(:financial_invoice, company_data: nil) }

        it 'return errors for invoice creation' do
          headers = { 'x-auth-token' => user.token }
          post '/api/v1/invoices', params: { format: :json, send_to: emails, invoice: invoice_params }, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body).to eq({ 'errors' => { 'company_data' => ["can't be blank"] } })
        end
      end
    end
  end
end
