class SyncCommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    Hashnode::SyncComments.new(post: @post).call if @post.hashnode_id?
    Devto::SyncComments.new(post: @post).call if @post.devto_id?

    redirect_to post_path(@post), notice: "Comments synchronized successfully."
  end
end
