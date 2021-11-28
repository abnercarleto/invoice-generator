require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  let(:json_body) { JSON.parse(response.body) }

  describe "POST /api/v1/auth/token" do
    let(:email) { "user-#{SecureRandom.hex(5)}@email.com" }

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

  describe 'GET /api/v1/auth/validate' do
    context 'when token is valid' do
      let(:token) { create(:identity_user).token }

      it 'create token for new user' do
        get '/api/v1/auth/validate', params: { token: token }

        expect(response).to have_http_status(:ok)
        expect(json_body).to eq({ 'validated' => true })
      end
    end

    context 'when token is not valid' do
      let(:token) { SecureRandom.hex }

      it 'create token for new user' do
        get '/api/v1/auth/validate', params: { token: token }

        expect(response).to have_http_status(:unauthorized)
        expect(json_body).to eq({ 'validated' => false })
      end
    end
  end

  describe 'DELETE /api/v1/auth/token' do
    context 'when user is not authorized' do
      it 'unauthorize request' do
        headers = { 'x-auth-token' => SecureRandom.hex }
        delete '/api/v1/auth/token', headers: headers

        expect(response).to have_http_status(:unauthorized)
        expect(json_body).to be_blank
      end
    end

    context 'when user is authorized' do
      let(:token) { create(:identity_user).token }

      it 'empty request' do
        headers = { 'x-auth-token' => token }
        delete '/api/v1/auth/token', headers: headers

        expect(response).to have_http_status(:ok)
        expect(json_body).to be_blank
      end
    end
  end
end
