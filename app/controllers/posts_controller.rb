class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: current_user.posts
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.posts.new
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      response = Devto::UpdatePost.new(api_key: current_user.devto_api_key, post: @post).call

      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def post_params
    params.require(:post).permit(:title, :md_content)
  end
end
