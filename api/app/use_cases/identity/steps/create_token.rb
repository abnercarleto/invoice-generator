module Identity
  module Steps
    class CreateToken < Micro::Case
      attributes :email, :permit_regenerate

      def call!
        return generate_token if user.token.blank?
        return regenerate_token if permit_regenerate

        Failure :token_already_generated
      end

      private

      def user
        @user ||= User.find_or_initialize_by(email: email)
      end

      def success_result
        Success result: { email: user.email, token: user.token }
      end

      def generate_token
        return success_result if user.persisted? ? user.regenerate_token : user.save

        Failure :cannot_generate_token, result: { errors: user.errors.messages }
      end

      def regenerate_token
        user.regenerate_token
        success_result
      end
    end
  end
end