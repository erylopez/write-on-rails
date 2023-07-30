class RepostsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])

    if @post.hashnode_id.present?
      redirect_to post_path(params[:post_id]) and return
    else
      Reposter::Hashnode.new(post: @post, user: current_user).call
    end
  end
end
