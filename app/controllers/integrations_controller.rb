class IntegrationsController < ApplicationController
  before_action :authenticate_user!

  def create
    if params[:user] && (params[:user][:hashnode_access_token].present? || params[:user][:devto_api_key].present?)
      current_user.update(params.require(:user).permit(:hashnode_access_token, :hashnode_username, :devto_api_key))
    end
  end
end
