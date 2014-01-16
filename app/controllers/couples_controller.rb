class CouplesController < ApplicationController
  before_filter :authenticate_user!
  
  def profile
    p "=========="
    p "in couple profile"
    p "=========="
    @couple = Couple.find_by_profile_name(params[:profile_name])
    render 'profile'
  end
end
