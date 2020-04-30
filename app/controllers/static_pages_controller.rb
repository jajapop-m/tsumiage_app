class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user =  current_user
      @post  = current_user.posts.build
      @posts = current_user.feed.where(post_id: nil).page(params[:page]) #feedでまとめて検索できるようにしたほうが良い。
    end
  end

  def help
  end
end
