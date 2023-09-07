class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.posts.order(created_at: :desc)
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
      Devto::UpdatePost.new(user: current_user, post: @post).call if @post.devto_id.present?
      Hashnode::UpdatePost.new(user: current_user, post: @post).call if @post.hashnode_id.present?
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    if @post.destroy
      Devto::UpdatePublished.new(user: current_user, devto_id: @post.devto_id, published: false).call if @post.devto_id.present?
      redirect_to posts_path, notice: "Post was successfully destroyed." and return
    end
  end

  def update_published_status_from_devto
    @post = current_user.posts.find(params[:id])

    render json: {error: "You need to connect your Dev.to account first"}, status: :unprocessable_entity and return unless current_user.devto_ready?
    response = Devto::UpdatePublished.new(user: current_user, devto_id: @post.devto_id, published: params[:published]).call

    if response
      @post.update(devto_draft: !@post.devto_draft)
      flash.now[:success] = "Post has been #{published_or_unpublished(published: params[:published])} on Devto."
    else
      flash.now[:error] = "Something went wrong. Please try again later."
    end
    respond_to do |format|
      format.html { redirect_to @post }
      format.turbo_stream { render :update_post }
    end
  end

  def delete_from_hashnode
    @post = current_user.posts.find(params[:id])
    response = Hashnode::DeletePost.new(user: current_user, post: @post).call
    if response.code == 200
      @post.update(hashnode_id: nil)
      flash.now[:success] = "Post has been deleted from Hashnode."
    else
      flash.now[:error] = "Something went wrong. Please try again later."
    end
    respond_to do |format|
      format.html { redirect_to @post }
      format.turbo_stream { render :update_post }
    end
  end

  protected

  def published_or_unpublished(published:)
    (published == "true") ? "published" : "unpublished"
  end

  def post_params
    params.require(:post).permit(:title, :md_content)
  end
end
