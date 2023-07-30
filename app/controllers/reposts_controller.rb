class RepostsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])

    case params[:platform]
    when "hashnode"
      if @post.hashnode_id.present?
        redirect_to post_path(params[:post_id]) and return
      end
      repost_to_hashnode and return
    when "devto"
      if @post.devto_id.present?
        redirect_to post_path(params[:post_id]) and return
      end

      repost_to_devto and return
    end
  end

  private

  def repost_to_hashnode
    if current_user.hashnode_ready?
      Reposter::Hashnode.new(post: @post, user: current_user).call
      redirect_to post_path(params[:post_id]), notice: "Your post has been reposted to Hashnode." and return
    else
      redirect_to dashboard_index_path, alert: "You need to connect your Hashnode account first." and return
    end
  end

  def repost_to_devto
    if current_user.devto_ready?
      Reposter::Devto.new(post: @post, user: current_user).call
      redirect_to post_path(params[:post_id]), notice: "Your post has been reposted to Dev.to." and return
    else
      redirect_to dashboard_index_path, alert: "You need to connect your Dev.to account first." and return
    end
  end
end
