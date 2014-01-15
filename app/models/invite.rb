class Invite < ActiveRecord::Base
  attr_accessible :accept_invitation, :p_email, :user_id, :waiting, :message
  
  # need to add custom error messages
  validates :p_email, :user_id, :presence => true
  validates :user_id, :uniqueness => true
  belongs_to :user
end
