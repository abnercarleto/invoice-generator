module Identity
  class CreateToken < Micro::Case
    attributes :email

    def call!
      if generate_token
        Success result: { token: user.token }
      else
        Failure result: { errors: user.errors.messages }
      end
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