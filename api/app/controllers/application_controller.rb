class ApplicationController < ActionController::API
  def authenticate_user
    @authenticated_user = Identity::User.find_by(token: request.headers['x-auth-token'])
    render(json: nil, status: :unauthorized) if @authenticated_user.blank?
  end

  def authenticated_user
    @authenticated_user
  end
end
