class CouplesController < ApplicationController
  before_filter :authenticate_user!
  
  def profile
    @couple = Couple.find_by_profile_name(params[:profile_name])
    render 'profile'
  end
  
  def update
    @couple = Couple.find(params[:id])
    if @couple.update_attributes(params[:couple])
      return :json => @couple
    else
      return :json => {:status => :unprocessable_entity}
    end
  end
  
end
