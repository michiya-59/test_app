class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      if user.confirmed_at.nil?
        flash[:alert] = 'メールアドレスを確認してください。'
        redirect_to login_path
      else
        flash[:success] = 'ログインに成功しました。トップ画面です。'
        session[:user_id] = user.id
        redirect_to root_path
      end
    else
      flash[:alert] = '無効なメールアドレスまたはパスワードです。'
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = 'ログアウトに成功しました。'
    redirect_to root_path
  end
end
