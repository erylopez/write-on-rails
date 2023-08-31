class RepostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @platform = params[:platform]

    if has_not_configured?(@platform)
      render json: {error: "Not configured"},
        status: :unprocessable_entity and return
    end

    case @platform
    when "hashnode"
      render json: {error: "Already posted"}, status: :unprocessable_entity and return if @post.hashnode_id.present?
      response = Reposter::Hashnode.new(post: @post, user: current_user).call
    when "devto"
      render json: {error: "Already posted"}, status: :unprocessable_entity and return if @post.devto_id.present?
      response = Reposter::Devto.new(post: @post, user: current_user).call
    end

    if response
      flash.now[:success] = "Post has been reposted on #{@platform}."
    else
      flash.now[:alert] = "Something went wrong."
    end

    respond_to do |format|
      format.html { redirect_to @post, notice: "Post has been reposted on #{@platform}" }
      format.turbo_stream
    end
  end

  private

  def has_not_configured?(platform)
    unless current_user.send("#{platform}_ready?")
      flash.now[:alert] = "You need to connect your #{platform.capitalize} account first."
      return true
    end

    false
  end
end
