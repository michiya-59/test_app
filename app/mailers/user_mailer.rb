class UserMailer < ApplicationMailer
  default from: 'nishino.michiya0509@gmail.com'

  def confirmation_email(user)
    @user = user
    @url = confirm_user_url(token: @user.confirmation_token)
    mail(to: @user.email, subject: '登録を確認してください')
  end
end
