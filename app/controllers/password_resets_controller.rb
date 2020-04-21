class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def create
    @user = User.find_by(email: params[:password_resets][:email])
    if @user
      @user.create_reset_digest
      @user.send_reset_email
      flash[:info] = "パスワード再発行のメールを送信しました。メールをご確認ください。"
      redirect_to root_url
    else
      flash.now[:danger] = "メールアドレスが間違っています。"
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "パスワードを更新しました。"
      redirect_to @user
    else
      flash.now[:danger] = "パスワードの更新に失敗しました。"
      render 'edit'
    end
  end

  private
    
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "リンクの有効期限が切れています。"
        redirect_to new_password_reset_url
      end
    end
end
