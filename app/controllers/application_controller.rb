class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user_owns_profile!
    couple = Couple.find_by_profile_name(params[:profile_name]) || Couple.find(params[:id])
    unless current_user.id == couple.u1_id || current_user.id == couple.u2_id
      render :text => "You don't have access to this profile"
    end
  end
  
  def after_sign_in_path_for(resource)
    @invites = current_user.invitations
    couple = current_user.couple
    
    if couple
      return "#{root_url}couples/#{couple.profile_name}"
    elsif Invite.has_current_invitation?(resource)
      return make_decision_invites_url
    elsif @invites.empty? && !Invite.has_current_invitation?(resource)
      return new_invite_url
    else #if @invites.waiting && !@invites.accept_invitation
      return waiting_invite_url(@invites.first)
    end
  end
  
end
