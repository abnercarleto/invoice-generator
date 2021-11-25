class Api::V1::AuthController < ApplicationController
  def generate_token
    Identity::CreateToken.
      call(email: params.require(:email)).
      on_success { |result| render json: result.data }.
      on_failure { |result| render json: result.data, status: :unprocessable_entity }
  end
end
