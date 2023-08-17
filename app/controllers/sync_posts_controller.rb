class SyncPostsController < ApplicationController
  def create
    platform = params[:platform]
    case platform
    when "hashnode"
      render json: {error: "You need to connect your Hashnode account first"}, status: :unprocessable_entity and return unless current_user.hashnode_ready?
      response = Hashnode::ImportPosts.new(user: current_user).call
    when "devto"
      redirect_to dashboard_index_path and return
    end

    redirect_to dashboard_index_path, notice: "Posts imported successfully"
  end
end
