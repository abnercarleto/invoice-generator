module Identity
  class CreateToken < Micro::Case
    attributes :email

    def call!
      return Success result: { token: user.token } if generate_token

      Failure result: { errors: user.errors.messages }
    end

    private

    def user
      @user ||= User.find_or_initialize_by(email: email)
    end

    def generate_token
      return user.save unless user.persisted?

      return user.regenerate_token
    end
  end
end