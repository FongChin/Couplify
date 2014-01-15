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
      redirect_to new_invite_url
    else
      flash.now[:errors] = @invite.errors.full_messages
      render 'new'
    end
    
  end
end
