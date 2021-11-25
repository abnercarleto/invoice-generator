class Identity::UserMailer < ApplicationMailer
  def new_token
    @token = params[:token]
    mail(to: params[:email], subject: 'Your access token')
  end
end
