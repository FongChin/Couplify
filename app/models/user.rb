class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :validatable, :recoverable,
         :rememberable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_name,
                  :last_name
  # attr_accessible :title, :body
  
  has_one :invitation, :class_name => "Invite", :foreign_key => :user_id
  
  def after_sign_in_path_for
    new_invite_url
  end
end
