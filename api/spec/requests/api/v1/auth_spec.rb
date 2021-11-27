require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  describe "POST /api/v1/auth/token" do
    let(:email) { "user-#{SecureRandom.hex(5)}@email.com" }
    let(:json_body) { JSON.parse(response.body) }

    context 'when user is new' do
      it 'create token for new user' do
        post '/api/v1/auth/token', params: { email: email, format: :json }

        expect(response).to have_http_status(:ok)
        expect(json_body).to eq({ 'sent_to' => email })
      end
    end

    context 'when user is persisted' do
      let!(:identity_user) { create(:identity_user, email: email) }

      context 'and not permit regenerate token' do
        it 'not create token for persisted user' do
          post '/api/v1/auth/token', params: { email: email, format: :json }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body).to eq({ 'token_already_generated' => true })
        end
      end

      context 'and permit regenerate token' do
        it 'create token for persisted user' do
          post '/api/v1/auth/token', params: { email: email, permit_regenerate: true, format: :json }

          expect(response).to have_http_status(:ok)
          expect(json_body).to eq({ 'sent_to' => email })
        end
      end
    end

    context 'when email is invalid' do
      let(:email) { "user-#{SecureRandom.hex(5)}.com" }

      it 'return email validation error' do
        post '/api/v1/auth/token', params: { email: email, format: :json }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(json_body).to eq({ 'errors' => { 'email' => ['is invalid'] } })
      end
    end
  end
end
