class CouplesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :current_user_owns_profile!, :only => [:profile]
  
  def profile
    @couple = Couple.find_by_profile_name(params[:profile_name])
    @posts_data = @couple.posts.page(1).per(20).includes(:owner)
                               .order('created_at DESC').to_json(:methods => [:image_url]).html_safe 
    @u1 = User.find(@couple.u1_id)
    @u2 = User.find(@couple.u2_id)
    @num_posts = @couple.posts.count
    render 'profile'
  end
  
  
  def update
    @couple = Couple.find(params[:id])
    if @couple.update_attributes(params[:couple])
      print "#{root_url}couples/#{@couple.profile_name}"
      redirect_to "/couples/#{@couple.profile_name}"
    else
      @errors = @couple.errors.full_messages
      render 'edit'
    end
  end
  
  def edit
    @couple = Couple.find_by_profile_name(params[:profile_name])
  end
end
