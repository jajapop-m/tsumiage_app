class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && user.activated? && authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "メールアドレスを確認が完了しました。"
      redirect_to user_path(user)
    else
      flash[:danger] = "無効なリンクです。"
      redirect_to resend_email_new_path
    end
  end

end