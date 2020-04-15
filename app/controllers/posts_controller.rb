class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def new
  end
  
  def show
    @post = Post.find_by(id: params[:id])
  end
  
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿が完了しました。"
      redirect_to root_url
    else
      redirect_to user_path(current_user)
      flash[:danger] = "投稿が失敗しました。"
    end
  end
  
  private
  
    def post_params
      params.require(:post).permit(:title, :content, :picture)
    end
  
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
