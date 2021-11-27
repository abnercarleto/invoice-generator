class Api::V1::AuthController < ApplicationController
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
end
