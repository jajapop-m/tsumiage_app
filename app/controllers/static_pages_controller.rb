class StaticPagesController < ApplicationController
  def home
    redirect_to user_path(current_user)  if logged_in?
  end

  def help
  end
end
