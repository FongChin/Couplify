class InviteEmailMailer < ActionMailer::Base
  default from: "invitation@couplify.me"
  
  def invite_email(invite)
    @invite = invite
    @user = User.find(invite.user_id)
    mail(to: invite.p_email, subject: "Someone has invited you to use Couplify")
  end
end
