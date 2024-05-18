class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.confirmation_email(@user).deliver_now
      flash[:success] = '登録確認のメールを確認してください。'
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def confirm
    user = User.find_by(confirmation_token: params[:token])
    if user.present? && user.confirm!
      flash[:success] = 'アカウントが確認されました。ログインしてください。'
      redirect_to login_path
    else
      flash[:alert] = user.errors.full_messages.join(", ") if user.present?
      flash[:alert] = '無効な確認トークンです。' if flash[:alert].blank?
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
