class IntegrationsController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:user] && (params[:user][:hashnode_access_token].present? || params[:user][:devto_api_key].present?)
      current_user.update(params.require(:user).permit(:hashnode_access_token, :hashnode_username, :devto_api_key))
      flash.now[:success] = "Your integrations have been updated."
    end
    respond_to do |format|
      format.html { redirect_to dashboard_index_path }
      format.turbo_stream
    end
  end
end
