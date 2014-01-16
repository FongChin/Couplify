class InvitesController < ApplicationController
  before_filter :authenticate_user!
  
  def new
    @invite = Invite.new
  end
  
  def create
    params[:invite][:user_id] = current_user.id
    @invite = Invite.new(params[:invite])
    if @invite.save
      # send an email to the partner
      @msg = InviteEmailMailer.invite_email(@invite)
      @msg.deliver!
      redirect_to waiting_invite_url(@invite)
    else
      flash.now[:errors] = @invite.errors.full_messages
      render 'new'
    end
  end
  
  def waiting
    @invite = Invite.find(params[:id])
    render 'waiting'
  end
  
  def make_decision
    has_current_invitation = Invite.has_current_invitation?(current_user)
    if has_current_invitation
      @invites = Invite.where(:p_email => current_user.email)
      render 'make_decision'
    else
      redirect_to new_invite_url
    end
  end
  
  def update
    @invite = Invite.find(params[:id])
    params[:invite][:waiting] = false
    if @invite.update_attributes(params[:invite])
      # email inviter about the acceptance?
      if @invite.accept_invitation
        # reject other invitations
        @invite.reject_other_invitations
        
        @couple = Couple.create_couple(@invite.user_id, current_user.id)
        if @couple.save
          redirect_to "#{root_url}couples/#{couple.profile_name}"
        else
          render :text => "something is wrong"
        end
      else
        redirect_to new_invite_url
      end
    else
      redirect_to new_invite_url
    end
    
  end
end
