class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :correct_user , only: [:edit, :destroy]
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @post = current_user.posts.build if logged_in?
    @posts = @user.posts.paginate(page: params[:page])
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "ユーザー登録が完了しました。"
      redirect_to @user
    else
      flash.now[:danger] = "登録が失敗しました。"
      render 'new'
    end
  end
  
  def index 
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
end
