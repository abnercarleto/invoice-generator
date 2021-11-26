module Identity
  class SendToken < Micro::Case
    attributes :identity_user

    def call!
      Identity::UserMailer.with(
        email: identity_user.email,
        token: identity_user.token
      ).new_token.deliver_now

      Success()
    end
  end
end