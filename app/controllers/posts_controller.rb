class PostsController < ApplicationController
  def index
    render json: current_user.posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.new
  end

  def create
    post = current_user.posts.create(post_params)
    redirect_to post
  end

  protected

  def post_params
    params.require(:post).permit(:title, :md_content)
  end
end
