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
      Devto::UpdatePost.new(api_key: current_user.devto_api_key, post: @post).call

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

  def update_published
    platform = params[:platform]
    @post = current_user.posts.find(params[:id])
    case platform
    when "Hashnode"
      render json: {error: "You need to connect your Hashnode account first"}, status: :unprocessable_entity and return unless current_user.hashnode_ready?
      # Hashnode::SyncPosts.new(user: current_user).call
    when "Dev.to"
      render json: {error: "You need to connect your Dev.to account first"}, status: :unprocessable_entity and return unless current_user.devto_ready?
      response = Devto::UpdatePublished.new(user: current_user, devto_id: @post.devto_id, published: params[:published]).call
    end
    if response
      update_published_attribute(platform)
      flash.now[:success] = "Post has been updated on #{platform}."
    else
      flash.now[:error] = "Something went wrong. Please try again later."
    end
    respond_to do |format|
      format.html { redirect_to @post }
      format.turbo_stream
    end
  end

  protected

  def update_published_attribute(platform)
    case platform
    when "Hashnode"
      @post.update(hashnode_draft: !@post.hashnode_published)
    when "Dev.to"
      @post.update(devto_draft: !@post.devto_draft)
    end
  end

  def post_params
    params.require(:post).permit(:title, :md_content)
  end
end
