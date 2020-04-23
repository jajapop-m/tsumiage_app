class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @user =  current_user
      @post  = current_user.posts.build
      @posts = current_user.feed.page(params[:page])
    end
  end

  def help
  end
end
