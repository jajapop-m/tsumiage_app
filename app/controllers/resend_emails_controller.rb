class ResendEmailsController < UsersController

  def new
  end
  
  def create
    @user = User.find_by(email: params[:resend_emails][:email]) 
    if @user && !@user.activated?
      @user.create_activation_digest
      @user.save
      @user.send_activation_email
      flash[:info] = "確認メールを再送しました。"
      redirect_to root_url
    elsif @user && @user.activated?
      flash[:info] = "すでにメールアドレスの確認済みです。ログインしてください。"
      redirect_to login_path
    else
      flash.now[:danger] = "登録済みのメールアドレスを入力してください。"
      render 'new'
    end
  end
end
