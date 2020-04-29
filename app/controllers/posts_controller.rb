class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def home
    if logged_in?
      redirect_to new_post_path
    else
      redirect_to root_url
    end
  end
  
  def index
    @posts = Post.page(params[:page]).per(30)
  end
  
  def new
    @post = Post.new
  end
  
  def show
    @post = Post.find_by(id: params[:id])
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def create
    if params[:form_expansion]  #画面遷移
      @post = Post.new(post_params)
      render new_post_path
    elsif params[:form_reduction] #画面遷移
      @post = Post.new(post_params)
      @user = current_user
      @posts = @user.posts.page(params[:page]).per(30)
      render '/users/show'
    else
      @post = current_user.posts.build(post_params)
      @post.edit_empty_field
      if @post.save
        flash[:success] = "投稿が完了しました。"
        redirect_to root_url
      else
        flash.now[:danger] = "投稿が失敗しました。"
        render '/posts/new'
      end
    end
  end
  
  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "編集が完了しました。"
      redirect_to current_user
    else
      flash[:danger] = "編集が失敗しました。"
      render 'edit'
    end
  end
  
  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to user_url(current_user)
  end
  
  private
  
    def post_params
      params.require(:post).permit(:title, :content, :picture, :started_at, :ended_at)
    end
  
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
