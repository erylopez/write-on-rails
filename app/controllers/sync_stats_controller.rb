class SyncStatsController < ApplicationController
  def create
    platform = params[:platform]
    case platform
    when "hashnode"
      render json: {error: "You need to connect your Hashnode account first"}, status: :unprocessable_entity and return unless current_user.hashnode_ready?
      Hashnode::SyncStats.new(user: current_user).call
    when "devto"
      render json: {error: "You need to connect your Dev.to account first"}, status: :unprocessable_entity and return unless current_user.devto_ready?
      Devto::SyncStats.new(user: current_user).call
    end

    redirect_to dashboard_index_path, notice: "Stats synchronized successfully."
  end
end
