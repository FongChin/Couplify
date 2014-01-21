class Couple < ActiveRecord::Base
  attr_accessible :anniversary_date, :profile_name, :u1_id, :u2_id
  
  validates :profile_name, :uniqueness => true, :presence => true
  validates :u1_id, :u2_id, :anniversary_date, :presence => true
  
  belongs_to :u1, :class_name => "User", :primary_key => :id, :foreign_key => :u1_id
  belongs_to :u2, :class_name => "User", :primary_key => :id, :foreign_key => :u2_id
  
  has_many :posts
  
  def self.create_couple(inviter_id, invitee_id)
    Couple.new({:u1_id => inviter_id, :u2_id => invitee_id, 
                          :profile_name => Time.now.to_i.to_s })
  end
  
  def self.user_has_profile?(user_id)
    @couples = Couple.where("u1_id = ? OR u2_id = ?", user_id, user_id)
    (@couples.empty?)? false : true
  end
  
  def self.get_couple_id(emails)
    email_arr = emails.split(", ")
    email_arr.each do |email|
      next unless email =~ /@couplify.me$/
      profile_name = email.gsub(/@couplify.me$/, "")
      couple = Couple.find_by_profile_name(profile_name)
      return (couple.nil?)? nil : couple.id
    end
  end
  
  def is_sender_owner?(sender_id)
    if sender_id == self.u1_id || sender_id == self.u2_id
      return true
    end
    return false
  end
  
end
