module Identity
  module Steps
    class SendToken < Micro::Case
      attributes :email, :token

      def call!
        Identity::UserMailer.
          with(email: email, token: token).
          new_token.
          deliver_now

        Success result: { sent_to: email }
      end
    end
  end
end