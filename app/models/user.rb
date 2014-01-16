class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :validatable, :recoverable,
         :rememberable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_name,
                  :last_name, :remember_me
  # attr_accessible :title, :body
  
  has_many :invitations, :class_name => "Invite", :foreign_key => :user_id
  
  def couple
    Couple.where('u1_id = ? OR u2_id = ?', self.id, self.id).first
  end
  
  def partner
    couple = self.couple
    return nil unless couple
    if self.id == couple.u1_id
      User.find(couple.u2_id)
    elsif self.id == couple.u2_id
      User.find(couple.u1_id)
    end
  end
end
