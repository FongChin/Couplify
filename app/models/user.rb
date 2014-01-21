class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :validatable, :recoverable,
         :rememberable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :first_name,
                  :last_name, :profile_image, :remember_me

  has_attached_file :profile_image, :styles => { 
    :medium => "300x300>", 
    :thumb => "30x30#" 
  }, :default_url => "/assets/:style/missing.jpg"
  
  has_many :invitations, :class_name => "Invite", :foreign_key => :user_id
  
  def self.get_id_from_email(from)
    email = Mail::Address.new(from).address
    user = User.find_by_email(email)
    (user.nil?)? nil : user.id
  end
  
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
  
  def basic_info_in_json
    self.attributes.select do |key, value|
      ["id", "email", "first_name", "last_name"].include?(key)
    end.to_json.html_safe
  end
end
