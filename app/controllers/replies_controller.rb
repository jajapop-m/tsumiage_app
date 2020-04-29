class RepliesController < PostsController
  before_action :correct_user, only: [:update, :destroy]
  
  def create
    @reply_post = current_user.posts.build(reply_params)
    original_post = Post.find(params[:id])
    @reply_post.reply(original_post)
    @reply_post.save
    flash[:success] = "リプライを投稿しました。"
    redirect_to original_post
  end
  
  def update
  end
  
  def destroy
    original_post = Post.find(params[:id])
    Post.find(params[:reply_id]).destroy
    flash[:success] = "リプライを削除しました。"
    redirect_to original_post
  end
  
  private
  
    def reply_params
      params.require(:post).permit(:content, :picture)
    end
    
    def correct_user
      @post = current_user.posts.find_by(post_id: params[:post_id])
      redirect_to root_url if @post.nil?
    end
end
