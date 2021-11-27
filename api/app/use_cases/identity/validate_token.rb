module Identity
  class ValidateToken < Micro::Case
    attributes :token

    def call!
      return Success result: { validated: true } if token_exists?

      Failure result: { validated: false }
    end

    private

    def token_exists?
      Identity::User.where(token: token).exists?
    end
  end
end