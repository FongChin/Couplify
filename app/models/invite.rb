class Invite < ActiveRecord::Base
  attr_accessible :accept_invitation, :p_email, :user_id, :waiting, :message
  
  # need to add custom error messages
  validates :p_email, :user_id, :presence => true
  validates :user_id, :uniqueness => true
  validate :invitee_does_not_have_couplify_profile
  
  belongs_to :user
  
  def invitee_does_not_have_couplify_profile
    invitee = User.find_by_email(self.p_email)
    if invitee && Couple.user_has_profile?(invitee.id)
      errors[:base] << "The person you want to invite already has a Couplify page."
    end
  end
  
  def self.has_current_invitation?(user)
    @invites = Invite.where("p_email = ? AND waiting = ?", user.email, true)
    (@invites.empty?)? false : true
  end
end
