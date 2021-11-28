class Api::V1::AuthController < ApplicationController
  before_action :authenticate_user, only: %w(destroy_token)

  def generate_token
    Identity::GenerateToken.
      call(email: params.require(:email), permit_regenerate: params.fetch(:permit_regenerate, false)).
      on_success { |result| render json: result.data }.
      on_failure { |result| render json: result.data, status: :unprocessable_entity }
  end

  def validate_token
    Identity::ValidateToken.
      call(token: params.require(:token)).
      on_success { |result| render json: result.data }.
      on_failure { |result| render json: result.data, status: :unauthorized }
  end

  def destroy_token
    Identity::RemoveToken.
      call(token: authenticated_user.token).
      on_success { render json: nil }
  end
end
