class StaticPagesController < ApplicationController
  
  def home
    if current_user
      redirect_to after_sign_in_path_for(current_user)
    else
      render "home"
    end
  end
end
