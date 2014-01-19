class CouplesController < ApplicationController
  before_filter :authenticate_user!
  
  def profile
    @couple = Couple.find_by_profile_name(params[:profile_name])
    @messages = @couple.messages.order('created_at')
    render 'profile'
  end
  
  def index
    redirect_to after_sign_in_path_for(current_user)
  end
  
  def update
    @couple = Couple.find(params[:id])
    if @couple.update_attributes(params[:couple])
      render :json => @couple
    else
      render :json => {:errors => @couple.errors }, :status => :unprocessable_entity
    end
  end
  
end
