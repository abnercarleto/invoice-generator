module Identity
  class RemoveToken < Micro::Case
    attributes :token

    def call!
      return Failure :user_not_found if user.blank?

      remove_token
      Success result: { logout: true }
    end

    private

    def user
      @user ||= Identity::User.find_by(token: token)
    end

    def remove_token
      user.update(token: nil)
    end
  end
end