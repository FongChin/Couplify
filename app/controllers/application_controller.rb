class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def pusher_client
    @pusher ||= Pusher::Client.new({
      app_id: ENV['PUSHER_APP_ID'],
      key: ENV['PUSHER_KEY'],
      secret: ENV['PUSHER_SECRET']
    })
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
