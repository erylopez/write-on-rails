class SyncPostsController < ApplicationController
  def create
    platform = params[:platform]
    case platform
    when "hashnode"
      render json: {error: "You need to connect your Hashnode account first"}, status: :unprocessable_entity and return unless current_user.hashnode_ready?
      Hashnode::ImportPosts.new(user: current_user).call
    when "devto"
      render json: {error: "You need to connect your Dev.to account first"}, status: :unprocessable_entity and return unless current_user.devto_ready?
      Devto::SyncPosts.new(user: current_user).call
    end

    redirect_to dashboard_index_path, notice: "Posts imported successfully"
  end
end
