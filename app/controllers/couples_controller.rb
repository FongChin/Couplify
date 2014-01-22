class CouplesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :current_user_owns_profile!, :only => [:profile]
  
  def profile
    @couple = Couple.find_by_profile_name(params[:profile_name])
    @posts = @couple.posts.page(1).per(20).includes(:owner).order('created_at DESC')
    @u1 = User.find(@couple.u1_id)
    @u2 = User.find(@couple.u2_id)
    @num_posts = @couple.posts.count
    render 'profile'
  end
  
  
  def update
    @couple = Couple.find(params[:id])
    if @couple.update_attributes(params[:couple])
      render :json => @couple
    else
      @errors = @couple.errors.full_messages
      render 'edit'
    end
  end
  
  def edit
    @couple = Couple.find_by_profile_name(params[:profile_name])
  end
end
