class Message < ActiveRecord::Base
  attr_accessible :body, :couple_id, :image_url, :user_id
  
  validates :user_id, :couple_id, :presence => true
  
  belongs_to :couple
  belongs_to :owner, :class_name => "User"
  
end
