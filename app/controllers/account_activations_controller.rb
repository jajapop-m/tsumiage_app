class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "メールアドレスの確認が完了しました。"
      redirect_to user_path(user)
    else
      flash[:danger] = "無効なリンクです。"
      redirect_to new_resend_email_path
    end
  end

end