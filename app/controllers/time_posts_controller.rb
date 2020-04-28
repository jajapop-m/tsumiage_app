class TimePostsController < PostsController
  before_action :logged_in_user

  def create
    @post = current_user.posts.new(time_started: true, title: "新しい投稿", content: current_user.name, started_at: Time.zone.now)
    @post.save
    redirect_to root_path
    # respond_to do |format| #正しく動作するためには、投稿一覧の自動更新を実装する必要がある。
    #   format.html { redirect_to root_path }
    #   format.js
    # end
  end
  
  def update
    @post = current_user.posts.find_by(time_started: true)
    @post.update_attributes(time_started: false, ended_at: Time.zone.now)
    redirect_to root_path
    # respond_to do |format|
    #   format.html { redirect_to root_path }
    #   format.js
    # end
  end
  
  def destroy
    post = current_user.posts.find_by(title: "新しい投稿", content: current_user.name)
    post.destroy
  end
  
  private
    
    def reset_time_post
      old_post = Post.find_by(time_started: true )
      old_post.destroy if old_post
    end
end
