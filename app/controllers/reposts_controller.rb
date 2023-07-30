class RepostsController < ApplicationController
  def create
    redirect_to post_path(params[:post_id])
  end
end
