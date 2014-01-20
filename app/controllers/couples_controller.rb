class CouplesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :current_user_owns_profile!, :only => [:profile]
  
  def profile
    @couple = Couple.find_by_profile_name(params[:profile_name])
    @posts = @couple.posts.includes(:owner).order('created_at DESC')
    @u1 = User.find(@couple.u1_id)
    @u2 = User.find(@couple.u2_id)
    render 'profile'
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
