class SessionsController < ApplicationController
  before_action :redirect_root_if_logged_in, only: [:new, :create]
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = 'ログインが成功しました。'
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'ログインが失敗しました。もう一度入力してください。'
      render 'new'
    end
  end
  
  def destroy
    log_out
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
  
  
  def redirect_root_if_logged_in
    redirect_to root_url if logged_in?
  end
end
