class PostsController < ApplicationController
  def new
  end
  
  def show
    @post = Post.find_by(id: params[:id])
  end
end
