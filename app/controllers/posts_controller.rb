class PostsController < ApplicationController
  def index
    render json: current_user.posts
  end

  def show
    @post = Post.find(params[:id])
  end
end